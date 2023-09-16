/*
#include <stdio.h>

void print_char(char string[], int n){
    for (int i=0; i<n; i++){
        printf("%c", string[i]);
    }
}

int scan_char(char string[], int size){
    int i = 0;
    char c = 0;
    while (c != '\n' && i < size){
        scanf("%c", &c);
        string[i] = c;
        i++;
    }
    return i;
}

void print_endian(int len_in, char out[]){
    //checks the smallest number on the input and uses its position to determine
    //what needs to be printed on the endian
    for (int i=0; i<32; i++){
        if (out[i] != 'n'){
            printf("%c", out[i]);
        }
    }
}
*/


int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
  return;
}


void _start()
{
  int ret_code = main();
  exit(ret_code);
}


#define STDIN_FD  0
#define STDOUT_FD 1


int power(int val, int expo){   //potenciação val^expo
    int out = 1;
    for (int i=0; i<expo; i++)
    {
        out *= val;
    }
    return out;
}

int dec_vector_to_dec_val(int vec[], int len){   //transforma vetor de intb10 em valor int
    int dec = 0;
    for (int i=0; i<len; i++){
        dec += vec[i] * power(10, len-i-1);
    }
    return dec;
}

int dec_val_to_bin(int bin[], int dec){//transforma valb10 em vetor int b2
    int len = 0;
    int dec_copy = dec;
    while (dec_copy > 0){
        dec_copy /= 2;
        len++;
    }

    for (int i=0; i<len; i++)
    {
        bin[len-1-i]= dec%2;  
        dec = dec/2;
    }
    return len;
}

void dec_val_to_dec_char(char out[], int dec, int len){//transforma valb10 em string
    int i = 0;
    int unit;
    while (dec > 0){
        unit = dec % 10;
        dec = dec / 10;
        out[len-1-i] = unit + 48;
        i++;
    }
}

void dec_char_to_dec_vector(char dec_char[], int dec_vector[]){//transforma string em vetor de int
    int i = 0;
    while (i<10){
        dec_vector[i] = dec_char[i] - 48;
        i++;
    }
}

int dec_val_to_hex(int dec_val, int hex[]){
    int dec_copy = dec_val;
    int len_hex = 0;
    while (dec_copy > 0){
        dec_copy /= 16;
        len_hex++;
    }

    int i=0;
    while (dec_val>0){
        hex[len_hex-i-1] = dec_val%16;
        dec_val = dec_val/16;
        i++;
    }


    return len_hex;
}

int hex_to_dec_val(int hex[], int hex_len){
    int out = 0;
    for (int i=0; i<hex_len; i++)
    {
        out += hex[i] * power(16, hex_len-1-i);
    }
    return out;
}

void str_to_hex(char str[], int hex[]){
    for (int i=2; i<10; i++){
        if (str[i] < 58){   //símbolo é numeral
        hex[i-2] = str[i] - 48;
        }
        else{   //símbolo é alfabeto
            hex[i-2] = str[i] - 87;
        }
    }
}

int bin_to_dec_val(int bin[]){
    int out = 0;
    for (int i=0; i<32; i++){
        out += bin[i] * power(2, 31-i);
    }
    return out;
}

void printable_char(int vector[], int size, char printable[]){
    for (int i=0; i<size; i++){
        if (vector[i] < 10){
            printable[i] = vector[i] + 48;
        }
        else{
            printable[i] = vector[i] + 87;
        }
    }
}

void change_endian(int in[], int out[], int len_in){
    int hold[8];

    for (int i=0; i<32; i++){out[i] = 0;}

    for (int byte=0; byte<4; byte++){

        if (len_in-8*byte>0){
            for (int bit=0; bit<8 ; bit++){
                if (len_in-bit-8*byte>0){
                    hold[7-bit] = in[len_in-bit-8*byte-1];
                }
                else{
                    hold[7-bit] = 0;
                }
            }
        }
        else{
            for (int i=0; i<8; i++){hold[i] = 0;}
        }

        for (int bit=0; bit<8; bit++){out[8*byte + bit] = hold[bit];}

    }
}

int len_decimal(int dec){
    int i=0;
    while (dec>0){
        dec /= 10;
        i++;
    }
    return i;
}

void hex_copy(char in[], char out[], int in_len){
    for (int i=0; i<in_len; i++){
        out[i] = in[i+2];
    }
}

void vector_copy(char out[], char in[], int in_len){
    for (int i=0; i<in_len; i++){
        if (in[0] == '-'){
            out[i-1] = in[i];
        }
        else{
            out[i] = in[i];
        }
    }
}

int len_val_dec(int val_dec){
    int i=0;
    while (val_dec > 0){
        val_dec /= 10;
        i++;
    }
    return i;
}

void complement(char bin[]){
    for (int i=0; i<32; i++){
        if (bin[i] == '1'){bin[i] = '0';}
        else {bin[i] = '1';}
    }
}

int main()
{
    char input_buffer[20];
    int n = read(STDIN_FD, input_buffer, 20);
    //int n = scan_char(input_buffer, 20);

    int bin[32];
    for (int i=0; i<32; i++){bin[i] = 0;}   //debug
    char bin_char[32];
    int len_bin;

    int dec_val;
    int dec_vector[10];
    char dec_char[10];
    int len_dec;

    int hex[10];
    char hex_char[10];
    int len_hex;

    if (input_buffer[1] == 'x'){ //hexadecimal

        len_hex = n - 3;

        hex_copy(input_buffer, hex_char, len_hex);
        str_to_hex(input_buffer, hex);   //removes the 0x and puts as ints into hex

        dec_val = hex_to_dec_val(hex, len_hex);
        len_dec = len_decimal(dec_val);

        len_bin = dec_val_to_bin(bin, dec_val);
        printable_char(bin, len_bin, bin_char);

        dec_val_to_dec_char(dec_char, dec_val, len_dec);
    }

    else{               //decimal
        len_dec = n - 1;
        vector_copy(dec_char, input_buffer, len_dec);

        if (input_buffer[0] == '-'){len_dec--;}

        dec_char_to_dec_vector(dec_char, dec_vector);
        dec_val = dec_vector_to_dec_val(dec_vector, len_dec);

        
        len_bin = dec_val_to_bin(bin, dec_val);


        printable_char(bin, len_bin, bin_char);

        len_hex = dec_val_to_hex(dec_val, hex);
        printable_char(hex, len_hex, hex_char);

    }
    
    
    int bin_end2[32];
    change_endian(bin, bin_end2, len_bin);
    int val_end2 = bin_to_dec_val(bin_end2);
    int len = len_val_dec(val_end2);
    char dec_endian2[10];
    dec_val_to_dec_char(dec_endian2, val_end2, len);


    char bin_symbol[2] = {'0', 'b'};
    char hex_symbol[2] = {'0', 'x'};
    char line[1] = {'\n'};


    for (int i=0; i<10; i++){
        if (hex_char[i] == '\n'){hex_char[i] = 0;}
        if (dec_char[i] == '\n'){dec_char[i] = 0;}
    }
    /*
    print_char(bin_symbol, 2);
    print_char(bin_char, len_bin);
    printf("\n");
    print_char(dec_char, len_dec);
    printf("\n");
    print_char(hex_symbol, 2);
    print_char(hex_char, len_hex);
    printf("\n");
    print_char(dec_endian2, len);
    printf("\n");
    */

    
        write(STDOUT_FD, bin_symbol, 2);
        write(STDOUT_FD, bin_char, len_bin);
        write(STDOUT_FD, line, 1);
        write(STDOUT_FD, dec_char, len_dec);
        write(STDOUT_FD, line, 1);
        write(STDOUT_FD, hex_symbol, 2);
        write(STDOUT_FD, hex_char, len_hex);
        write(STDOUT_FD, line, 1);
        write(STDOUT_FD, dec_endian2, len);
        write(STDOUT_FD, line, 1);
    

    return 0;
}
