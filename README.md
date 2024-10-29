# Monte Carlo Integration Project

## Opis projektu

Projekt implementuje metodę Monte Carlo do aproksymacji wartości całek dla wybranych funkcji matematycznych. Program wykonuje obliczenia dla różnych wartości \( n \) (liczba punktów) i \( k \) (liczba powtórzeń). Wyniki są wizualizowane za pomocą wykresów generowanych w `gnuplot`.

### Funkcje

Projekt obsługuje trzy funkcje:
- **f1(x) = x^(1/3)** na przedziale [0, 8], gdzie dokładna wartość całki wynosi 12,
- **f2(x) = sin(x)** na przedziale [0, π], gdzie dokładna wartość całki wynosi 2,
- **f3(x) = 4x(1 - x)^3** na przedziale [0, 1], gdzie dokładna wartość całki wynosi 0.4.

### Struktura plików

- **main.cpp**: Główny plik źródłowy, który implementuje metodę Monte Carlo i definiuje funkcje.
- **header.cpp**: Plik nagłówkowy zawierający definicje funkcji matematycznych.
- **run.sh**: Skrypt Bash do automatyzacji kompilacji, generowania danych i tworzenia wykresów.
- **Makefile**: Plik make do kompilacji programu `montecarlo`.
- **README.md**: Dokumentacja projektu.

### Wymagania

- Kompilator C++ (np. `g++`).
- `gnuplot` do generowania wykresów.
- System operacyjny wspierający skrypty Bash (np. Linux, MacOS).

## Instrukcja użytkowania

1. **Kompilacja programu**

   Aby skompilować program, użyj `make`:
   ```bash
   make
   ```
   Jeśli kompilacja się nie powiedzie, sprawdź pliki źródłowe pod kątem błędów.


2. **Uruchomienie programu**

   Program `monte_carlo` można uruchomić z następującymi argumentami:

   ```bash
   ./monte_carlo <k> <n> <funkcja>
   ```
