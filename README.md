# Terrain Navigation System

Программа для анализа рельефа местности, построения триангуляции Делоне, диаграмм Вороного и поиска оптимальных маршрутов с учетом препятствий.

## 📌 Основные функции
- Генерация/загрузка карты высот (формат BMP и GNUPLOT)
- Кластеризация объектов методом k-means
- Триангуляция Делоне с учетом высот
- Построение диаграммы Вороного
- Поиск пути с ограничениями по углу наклона тележки и ее радиуса
  

## 💻️ Системные требования

### Обязательные компоненты
1. **Компилятор C++17**  
   - `g++` (GCC) или `clang++`  
   - *Зачем*: Для сборки исходного кода программы

2. **Gnuplot 5.4+**  
   - *Что это*: Программа для построения графиков  
   - *Зачем*: Для визуализации карт высот, триангуляции и маршрутов  
   - Установка:  
     ```bash
     sudo apt install gnuplot  # Linux (Debian/Ubuntu)
     brew install gnuplot      # macOS (Homebrew)
     ```

### Опциональные компоненты
3. **CMake 3.12+**  
   - *Что это*: Система управления сборкой  
   - *Зачем*: Для упрощённой компиляции в разных ОС (если не используете прямой вызов g++)  
   - Установка:  
     ```bash
     sudo apt install cmake  # Linux
     ```

### Совместимость ОС
✅ **Полная поддержка**:  
- Linux (Ubuntu/Debian/Arch)  
- macOS (Intel/Apple Silicon)  

⚠️ **Ограниченная поддержка**:  
- Windows (требуется WSL2 или Cygwin)  
  - Рекомендуемый способ:  
    ```bash
    wsl --install -d Ubuntu
    ```

### Проверка установки
```bash
# Проверить версии компонентов
g++ --version
gnuplot --version
cmake --version
```

## 🚀 Запуск программы

### Способ 1: Ручная компиляция и запуск
```bash
# Переход в папку проекта
cd Gauss

# Компиляция
g++ -std=c++17 main.cpp -o terrain_navigator

# Запуск 
./terrain_navigator
```

### Способ 2: Автоматический скрипт (рекомендуется)
```bash
cd Gauss
chmod +x auto.sh  # Даем права на выполнение (только при первом запуске)
./auto.sh
```

### Способ 3: С CMake (опционально)
```bash
cd Gauss
mkdir build && cd build
cmake ..
make
./terrain_navigator
```

## 📂 Файлы проекта
```
~/Gauss/                                # Корневая папка проекта
├── archive                             # Старые версии
├── .gitignore                          # Игнорирует файл archive
├── LICENSE                             # Лицензия
├── README.md                           # Документация
├── src/
│   ├── config.txt                      # Основные параметры системы
│   ├── commandsGauss.txt               # Пример командного файла, генерирующий поле гаусами
│   ├── commandsRead.txt                # Пример командного файла, генерирующий поле картинкой Read.bmp
│   ├── main.cpp                        # Исходный код программы
│   └── auto.sh                         # Скрипт, запускающий main.cpp и читающий файл commandsGauss.txt
└── results/                            # Все результаты работы (внутри Gauss)
    ├── docs/
    │   ├── help.txt                    # Справочник
    │   ├── log_control.txt             # Логи Control
    │   └── log_interface.txt           # Логи Interface
    └── visualizations/                 # Все визуализации
        ├── binary_with_components.png  # Факторы компонент
        ├── delaunay_triangulation.png  # Триангуляция Делоне
        ├── voronoi_diagram.png         # Диаграмма Вороного
        ├── landscape.png               # 3D-вид поля (GNUPLOT)
        ├── path_plot2D.png             # Маршрут 2D
        ├── path_plot3D.png             # Маршрут 3D
        ├── output_kmeans.bmp           # K-means
        ├── output_kmeans_kern.bmp      # K-means с ядрами
        ├── slice.bmp                   # Бинаризированная карта
        ├── Read.bmp                    # Поле для чтения
        └── output.bmp                  # Сгенерированная карта
```


## 🛠 Команды управления (для командного файла command.txt)

| Команда              | Параметры                      | Описание                                                                 |
|----------------------|--------------------------------|--------------------------------------------------------------------------|
| help                 | -                              | Создание файла с пояснением команд                                       |
| init                 | -                              | Инициализация поля                                                       |
| g                    | x y sx sy h                    | Создает гаусс с центром (x,y), размерами (sx,sy) и высотой h             |
| generate             | -                              | Складывает все добавленные гауссы в итоговое поле                        |
| gnuplot              | filename.png                   | Сохраняет 3D-визуализацию поля в PNG файл                                |
| PlotMetedata         | filename.png                   | Визуализирует метаданные компонент с границами и центрами                |
| PlotVoronoi          | filename.png                   | Строит диаграмму Вороного по текущей триангуляции                        |
| PlotDelaunay         | filename.png                   | Визуализирует триангуляцию Делоне                                        |
| PlotPath             | filename.png                   | Отображает найденный путь между точками A и B                            |
| bmp_write            | filename.bmp [Full/Binary]     | Сохраняет поле в BMP: Full - полное, Binary - бинаризованное             |
| bmp_read             | filename.bmp                   | Загружает поле из BMP файла                                              |
| bin                  | slice [Peaks/Valleys/All]      | Бинаризация: Peaks - только пики, Valleys - впадины, All - по модулю     |
| wave                 | noisy                          | Удаляет компоненты размером ≤ noisy как шум                              |
| k_means              | k                              | Кластеризует данные в k кластеров                                        |
| k_means_kern         | kk                             | Кластеризация с ядрами размера kk                                        |
| triangulate          | -                              | Строит триангуляцию Делоне по центрам компонент                          |
| find_path            | Ax Ay Bx By                    | Ищет путь между точками A и B через триангуляцию                         |
| Plot3DPath           | filename.png                   | Сохраняет 3D-визуализацию путя в PNG файл                                |
| plotInteractive3DPath| -                              | Интерактвный 3D режим с путем                                            |
| end                  | -                              | Завершает работу программы                                               |


## ⚙️ Параметры конфигурационного файла (config.txt)

| Параметр                     | Значение                                       | Описание                                                                         |
|------------------------------|------------------------------------------------|----------------------------------------------------------------------------------|
| fieldWidth                   | `fieldWidth`                                   | Ширина рабочего поля в пикселях                                                  |  
| fieldHeight                  | `fieldHeight`                                  | Высота рабочего поля в пикселях                                                  |
| defaultX                     | `defaultX`                                     | Стандартная X-координата центра гауссова распределения по умолчанию              |
| defaultY                     | `defaultY`                                     | Стандартная Y-координата центра гауссова распределения по умолчанию              |
| defaultSx                    | `defaultSx`                                    | Стандартное отклонение по оси X по умолчанию                                     |
| defaultSy                    | `defaultSy`                                    | Стандартное отклонение по оси Y по умолчанию                                     |
| defaultH                     | `defaultH`                                     | Стандартная высота гауссова распределения по умолчанию                           |
| defaultGnuplot               | `filename_gnuplot.png`                         | Путь к файлу для сохранения 3D-визуализации по умолчанию                         |
| defaultPlotMetedata          | `filename_metadata.png`                        | Путь к файлу для визуализации метаданных компонент по умолчанию                  |
| defaultPlotVoronoi           | `filename_voronoi.png`                         | Путь к файлу для диаграммы Вороного по умолчанию                                 |
| defaultPlotDelaunay          | `filename_delaunay.png`                        | Путь к файлу для триангуляции Делоне по умолчанию                                |
| defaultPlotPath              | `filename_path.png`                            | Путь к файлу для визуализации маршрута по умолчанию                              |
| defaultWrite                 | `filename_write.bmp`                           | Путь к файлу для сохранения BMP-изображения по умолчанию                         |
| defaultWriteModeImage        | `writeMode`                                    | Режим сохранения BMP (Full/Binary) по умолчанию                                  |
| defaultRead                  | `filename_read.bmp`                            | Путь к файлу для загрузки BMP-изображения по умолчанию                           |
| defaultSlice                 | `defaultSlice`                                 | Порог бинаризации по умолчанию                                                   |
| defaultBinMode               | `binMode`                                      | Режим бинаризации (Peaks/Valleys/All) по умолчанию                               |
| defaultNoisy                 | `defaultNoisy`                                 | Порог для удаления шумовых компонент по умолчанию                                |
| defaultKlaster               | `defaultKlaster`                               | Количество кластеров для k-mean по умолчанию                                     |
| defaultKlasterKern           | `defaultKlasterKern`                           | Размер ядра для кластеризации по умолчанию                                       |
| defaultpointA_x              | `pointA_x`                                     | X-координата точки A для поиска пути по умолчанию                                |
| defaultpointA_y              | `pointA_y`                                     | Y-координата точки A для поиска пути по умолчанию                                |
| defaultpointB_x              | `pointB_x`                                     | X-координата точки B для поиска пути по умолчанию                                |
| defaultpointB_y              | `pointB_y`                                     | Y-координата точки B для поиска пути по умолчанию                                |
| defaultPlot3DPath            | `filename_plot3dpath.png`                      | Путь к файлу для 3D-визуализации маршрута по умолчанию                           |
| vehicleRadius                | `vehicleRadius`                                | Радиус транспортного средства                                                    |
| maxSideAngle                 | `maxSideAngle`                                 | Максимальный угол поворота вбок (градусы)                                        |
| maxUpDownAngle               | `maxUpDownAngle`                               | Максимальный угол наклона вверх/вниз (градусы)                                   |
| logFileNameInterface         | `filename_log_interface.txt`                   | Путь к лог-файлу интерфейса                                                      |
| logFileNameControl           | `filename_log_control.txt`                     | Путь к лог-файлу управления                                                      |
| FiltrationLogLevelInterface  | `logLevelInterface`                            | Уровень логирования интерфейса (TRACE/DEBUG/INFO/WARNING/ERROR/CRITICAL/OFF)     |
| FiltrationLogLevelControl    | `logLevelControl`                              | Уровень логирования управления (TRACE/DEBUG/INFO/WARNING/ERROR/CRITICAL/OFF)     |


## ⚠️ Важно
1. Всегда начинайте с команды init
2. Точки A/B задаются в config.txt
3. Маршрут будет найден не всегда!
4. Для триангуляции и построения пути, нужно чтобы количество компонент было больше 3
5. Если пользуетесь программой, то важно использовать ту же файловую структуру!
6. Путь к файлу пишем полностью
7. Важен порядок команд, не забывайте делать картинки после команд
8. Для команды bmp_write не полагайтесь на значения по умолчанию
9. Точки A и B должны попадать в триангуляцию
10. Уровень "равнины" = 127, чтобы метод записи поля по гаусам согласовался с записью по картике
11. Условия проходимости: 1)Если угол наклона в любом пикселе путя превосходит допустимый (по направлению или вбок) 2) Расстояние до препятсвия на срезе меньше радиуса

## 📜 Командный файл (примеры)
1) Если нужно прочитать данные с файла Read.bmp
```
init
help
bmp_read /home/log/Gauss/results/visualizations/Read.bmp
gnuplot /home/log/Gauss/results/visualizations/gnuplot.png
bmp_write /home/log/Gauss/results/visualizations/Polew.bmp Full
bin 20 All
bmp_write /home/log/Gauss/results/visualizations/Slice.bmp Binary
wave 10
PlotMetedata /home/log/Gauss/results/visualizations/Metadata.png
k_means 5
bmp_write /home/log/Gauss/results/visualizations/kmeans.bmp Binary
triangulate
PlotVoronoi /home/log/Gauss/results/visualizations/Diagramma_Voronova.png
PlotDelaunay /home/log/Gauss/results/visualizations/Triangulation_Delone.png
find_path
PlotPath /home/log/Gauss/results/visualizations/Path.png
end
```
2) Если данные вводятся с помощью гаусов
```
init
help
g 99 50 25 25 -50
g 50 50 20 20 50
g 200 50 20 20 -50
g 50 200 20 20 50
g 189 180 20 20 -50
g 130 130 20 20 50
generate
gnuplot /home/log/Gauss/results/visualizations/gnuplot.png
bmp_write /home/log/Gauss/results/visualizations/Pole.bmp Full
bin 20 All
bmp_write /home/log/Gauss/results/visualizations/Slice.bmp Binary
wave 10
PlotMetedata /home/log/Gauss/results/visualizations/Metadata.png
k_means 5
bmp_write /home/log/Gauss/results/visualizations/kmeans.bmp Binary
triangulate
PlotVoronoi /home/log/Gauss/results/visualizations/Diagramma_Voronova.png
PlotDelaunay /home/log/Gauss/results/visualizations/Triangulation_Delone.png
find_path
PlotPath /home/log/Gauss/results/visualizations/Path.png
end
```

## 📃️ Конфигурационный файл (пример)
```
fieldWidth 250
fieldHeight 250
defaultX 50.0
defaultY 50.0
defaultSx 20.0
defaultSy 20.0
defaultH 200.0
defaultGnuplot /home/log/Gauss/results/visualizations/Gnuplot.png
defaultPlotMetedata /home/log/Gauss/results/visualizations/Metadata.png
defaultPlotVoronoi /home/log/Gauss/results/visualizations/Voronoi.png
defaultPlotDelaunay /home/log/Gauss/results/visualizations/Delaunay.png
defaultPlotPath /home/log/Gauss/results/visualizations/Path.png
defaultWrite /home/log/Gauss/results/visualizations/Write.bmp
defaultWriteModeImage Full
defaultRead /home/log/Gauss/results/visualizations/Read.bmp
defaultSlice 127
defaultBinMode All
defaultNoisy 10
defaultKlaster 5
defaultKlasterKern 5
defaultpointA_x 150.0
defaultpointA_y 150.0
defaultpointB_x 160.0
defaultpointB_y 160.0
defaultPlot3DPath /home/log/Gauss/results/visualizations/Plot3DPath.png
vehicleRadius 5
maxSideAngle 90.0
maxUpDownAngle 90.0
logFileNameInterface /home/log/Gauss/results/docs/loginterface.txt
logFileNameControl /home/log/Gauss/results/docs/logcontrol.txt
FiltrationLogLevelInterface INFO
FiltrationLogLevelControl INFO
```

##### ======================================
## 🔄 SAFE WORKFLOW v1.0
##### ======================================
#### Философия: "Мои изменения — священны 😤️, main обновляется без боли 😇️"

### 1️⃣ Начало работы (без опасного pull!)
```
git checkout main
git checkout -b feature/improved-structure  # Создаем ветку ОТ локального main
```

### 2️⃣ Работа с файлами
#### Редактируете файлы -> сохраняете -> проверяете:
```
git status
```

### 3️⃣ Фиксация изменений в ветке
```
git add .
git commit -m "Мои изменения ..."
git push origin feature/improved-structure
```

### 4️⃣ Лучший способ обновить main:

#### --- Способ 1: Идеальный мир (без конфликтов) ---
```
git checkout main
git merge --squash feature/improved-structure #Лень решать конфликты? Пишем "git reset --merge" после и идем ко 2 способу!
git commit -m "РЕЛИЗ: Новая структура проекта"
git push origin main
```

#### --- Способ 2: Жёсткий reset (когда конфликты лень решать) ---
```
git checkout main
git reset --hard feature/improved-structure
git push origin main --force-with-lease
```

#### --- Способ 3: Аккуратный мерж (если main меняли другие) ---
```
git fetch origin
git merge origin/main --no-commit
[ручное разрешение конфликтов]
git commit -m "Мерж улучшенной структуры"
git push origin main
```

### 5️⃣ Создание тега
```
git tag -a v2.0.0 -m "Обновленная структура проекта"
git push origin v2.0.0
```

### 6️⃣ Очистка
```
git branch -D feature/improved-structure
git push origin --delete feature/improved-structure
```


## 📄 Лицензия
Этот проект лицензирован под MIT License. Вы можете свободно использовать, изменять и распространять код, при условии, что вы укажете автора.

Разрешенные действия:

   1. Использование кода в коммерческих и некоммерческих проектах
   2. Модификация кода
   3. Распространение кода

Обязательное условие: при использовании кода, пожалуйста, укажите ссылку на автора.

Developed with ❤️ by **DebugDestroy**  
[GitHub Profile](https://github.com/DebugDestroy)
