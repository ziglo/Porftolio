# imported necessary libraries. 

import pandas as pd  
import requests  
import time  
import numpy as np  

# Define the API URL for fetching NBA stats for the 2014-15 regular season
url = "https://stats.nba.com/stats/leagueLeaders?LeagueID=00&PerMode=PerGame&Scope=S&Season=2014-15&SeasonType=Regular%20Season&StatCategory=PTS"

# Send get request to parse json file. 
r = requests.get(url=url).json()

# get column headers from the 'resultSet' key in the API.

headers = r['resultSet']['headers']  

# Define the column names for the final data frame
df_cols = ['Year', 'Season_Type'] + headers

# Create an final dataframe that will utilize the columns we created from df_cols. 
df = pd.DataFrame(columns=df_cols)

# defined season types to get both regular season and playoffs. 
season_types = ['Regular%20Season', 'Playoffs']

# utilized approximately 10 seasons from 14-15 to 23-24. Did not include current season as it has not yet been finished. 
years = ['2014-15', '2015-16', '2016-17', '2017-18', '2018-19', '2019-20', '2020-21', '2021-22', '2022-23', '2023-24']

 # Record the start time for measuring total runtime, utilized to calculate for loop. 
begin_loop = time.time()

# nested for loop for years and season_types to get data and process it. 
for y in years:
    for s in season_types:
        # Utilize initial API url and use f strings to replace year and season type with indexes y and s. 
        api_url = f"https://stats.nba.com/stats/leagueLeaders?LeagueID=00&PerMode=PerGame&Scope=S&Season={y}&SeasonType={s}&StatCategory=PTS"
        response = requests.get(url=api_url).json()
        
        # Extract column headers and data from the 'resultSet' for each iteration.
        headers = response['resultSet']['headers']
        # Create a DataFrame for the stats
        tdf = pd.DataFrame(response['resultSet']['rowSet'], columns=headers)  
        
        # Create a temporary DataFrame with the year and season type 
        tdf2 = pd.DataFrame({'Year': [y] * len(tdf), 
                                 'Season_type': [s] * len(tdf)})  
        
        # Add the two dataframes together to create combined dataframe. 
        cdf = pd.concat([tdf2, tdf], axis=1)
        
        # Create a main dataframe using the combined df.
        df = pd.concat([df, cdf], axis=0)
            
        # Purposely 'lag' or set a timer to prevent NBA server thinking program is a bot. 
        # Generate a random delay between 5 and 30 seconds
        lag = np.random.uniform(low=5, high=30)
        print(f"...waiting {round(lag, 1)} seconds")
        time.sleep(lag)  # Pause execution for the generated delay

# print out total runtime. 
print(f'Process completed. Total runtime : {round((time.time()-begin_loop)/60, 2)} minutes')

# Export the final DataFrame to an Excel file using openpyxl
df.to_excel('NBAPlayerData.xlsx', index=False)
