 /* Filename: letterFreq.c
 *
 * Description: Program will calculate the frequency of letter occurences in text from standard input.
 *
 * Author: Austin Ro
 *
 * Used linux ubuntu to run C program, ran via ./letterfreq < example.txt.  
 */

#include <stdio.h>
#include <stdbool.h>

bool upper_letter(int ch){
    return (ch >= 65 && ch <= 90);
    }

bool lower_letter(int ch){
    return (ch >= 97 && ch <= 122);
}

int main(void){

    unsigned int total_letter = 0;
    int letter_counter[26] = {0};
    int letter;

    while((letter = getchar()) != EOF){
        if(upper_letter(letter)){
            letter_counter[letter-65]++;
            total_letter++;
        }
        if(lower_letter(letter)){
            letter_counter[letter-97]++;
            total_letter++;
        }
        
    }

    for(int i = 0; i < 26; i++){
        if(letter_counter[i] > 0)
            printf("%c %.4f\n",'a' + i, (float)letter_counter[i]/total_letter);
        }
    

    return 0;

}