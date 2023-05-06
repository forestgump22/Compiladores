#include <iostream>
#include <string>
using namespace std;
int main() {
    std::string emoji = u8"\U0001F600";
    cin>> emoji; // el código Unicode del emoji son 4 bytes, por lo que utilizamos u8 antes de la cadena para indicar que es una cadena UTF-8
    std::cout << emoji << std::endl; // mostrar el emoji en la salida estándar

    return 0;
}