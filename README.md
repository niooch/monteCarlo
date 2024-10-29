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

   Program `montecarlo` można uruchomić z następującymi argumentami:

   ```bash
   ./monte_carlo <k> <funkcja> <n>
   ```
    - k: liczba powtórzeń (np. 50).
    - funkcja: wybrana funkcja (f1, f2, f3 lub pi).
    - n: liczba punktów użytych w metodzie Monte Carlo (np. 10000).

    Przyklad:
    ```bash
    ./monte_carlo 50 f1 1000
    ```

3. Uruchomienie sktryptu

   Skrypt run.sh pozwala na automatyzację eksperymentów i generowanie wykresów. Składnia:
   ```bash
   bash run.sh <k> <funkcja> <wartości n>
   ```
    - k1: liczba powtórzeń dla pierwszego eksperymentu (np. 5).
    - k2: liczba powtórzeń dla drugiego eksperymentu (np. 50).
    - funkcja: wybrana funkcja (f1, f2, f3 lub pi).
    - wartości n: lista wartości n oddzielonych spacją lub generowanych za pomocą seq.

    ```bash
    bash run.sh 5 50 f1 $(seq 50 50 5000)
    ```
    Ten przykład uruchomi eksperymenty dla funkcji f1 z liczbą powtórzeń 5 i 50, dla wartości n od 50 do 5000 z krokiem 50.

## Wyniki

- **Pliki danych**: Skrypt generuje pliki `.dat` z danymi dla każdej funkcji, np. `f1_data_k1.dat` i `f1_data_k2.dat`.
- **Wykresy**: Skrypt generuje wykresy `.png` dla każdej funkcji, np. `plot_f1_k1.png` i `plot_f1_k2.png`. Na wykresach przedstawiono:

  - **Niebieskie punkty**: pojedyncze obliczenia dla każdej wartości `n`.
  - **Czerwone punkty**: średnie przybliżenie dla każdej wartości `n`.
  - **Zielona linia**: dokładna wartość całki dla wybranej funkcji.

### Przykład wyniku

Każdy wygenerowany wykres zawiera:

- **Niebieskie punkty**, które reprezentują poszczególne przybliżenia dla danej wartości `n`.
- **Czerwone punkty**, które pokazują średnią wartość przybliżenia dla danej wartości `n`.
- **Zieloną linię**, oznaczającą dokładną wartość całki.

## Funkcja pi(x)

Funkcja `pi(x)` została dodana w celu estymacji wartości liczby **π** za pomocą metody Monte Carlo. Szczegóły:

- **Definicja funkcji**: \( \pi(x) = \dfrac{4}{1 + x^2} \)
- **Przedział całkowania**: \([0, 1]\)
- **Dokładna wartość całki**: π (liczba pi)

### Jak uruchomić estymację π

Aby uruchomić program dla funkcji `pi`, użyj:

```bash
./monte_carlo <k> <n> pi
```

Przyklad:
```bash
./monte_carlo 50 10000 pi
```
Możesz również użyć skryptu run.sh:
```bash
bash run.sh 5 50 pi $(seq 1000 1000 10000)
```
## Uwagi

- **Dokładność estymacji**: Dokładność wyników zależy od wartości `n` (liczby punktów). Większe `n` zwiększa dokładność, ale wydłuża czas obliczeń.
- **Wymagane uprawnienia**: Upewnij się, że skrypt `run.sh` ma prawa do wykonywania:

  ```bash
  chmod +x run.sh
  ```
