# Terrain Navigation System

Программа для анализа рельефа местности, построения триангуляции Делоне, диаграмм Вороного и поиска оптимальных маршрутов с учетом препятствий.

## 📌 Основные функции
- Генерация/загрузка карты высот (формат BMP и GNUPLOT)
- Кластеризация объектов методом k-means
- Триангуляция Делоне с учетом высот
- Построение диаграммы Вороного
- Поиск пути с ограничениями по углу наклона тележки
  

## ⚙️ Системные требования

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
│   ├── commands.txt                    # Пример командного файла
│   ├── main.cpp                        # Исходный код программы
│   └── auto.sh                         # Скрипт, запускающий main.cpp и читающий файл commands.txt
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
        ├── path_plot.png               # Маршрут
        ├── output_kmeans.bmp           # K-means
        ├── output_kmeans_kern.bmp      # K-means с ядрами
        ├── slice.bmp                   # Бинаризированная карта
        └── output.bmp                  # Сгенерированная карта
```


## 🛠 Команды управления

| Команда            | Параметры              | Описание                                                                |
|--------------------|------------------------|-------------------------------------------------------------------------|
| help               | -                      | Создание файла с пояснением команд                                      |
| init               | -                      | Инициализация поля                                                      |
| g                  | x y sx sy h            | Создает гаусс                                                           |
| generate           | -                      | Складывает гауссы                                                       |
| gnuplot            | -                      | Рисует картинку в gnuplot                                               |
| bmp_write          | -                      | Создает черно-белую серую картинку BMP                                  |
| bmp_read           | filename.bmp           | Чтение BMP файла и инициализация поля новыми размерами                  |
| bin                | integer_number         | Срез: все, что выше или ниже integer_number - черное, остальное - белое |
| k_means            | k                      | Выделение k кластеров                                                   |
| k_means_kern       | kk                     | Алгоритм k-means с ядрами размера kk                                    |
| triangulate        | -                      | Построение триангуляции                                                 |
| find_path          | -                      | Построение маршрута между точками A и B                                 |
| end                | -                      | Это конец программы                                                     | 


## ⚠️ Важно
1. Всегда начинайте с команды init
2. Точки A/B задаются в config.txt
3. Маршрут будет найден не всегда!
4. Для триангуляции и построения пути, нужно чтобы количество компонент было больше 3
5. Если пользуетесь программой, то важно использовать ту же файловую структуру!


## 📜 Командный файл (примеры)
1) Если нужно прочитать данные с файла cat.bmp
```
init
help
bmp_read cat.bmp
gnuplot
bmp_write
bin 127
k_means 2
k_means_kern 3
triangulate
find_path
end
```
2) Если данные вводятся с помощью гаусов
```
init
help
g 99 50 25 25 200
g 50 50 20 20 200
g 200 50 20 20 200
g 50 200 20 20 200
g 189 180 20 20 200
g 130 130 20 20 200
generate
gnuplot
bmp_write
bin 127
k_means 5
triangulate
find_path
end
```

## 🔄 Development Workflow

### 1. Создаем ветку от актуального main
git checkout main
git pull origin main
git checkout -b feature/my-feature

### 2. Работаем над изменениями...
#### (создаем/редактируем файлы)

### 3. Пушим ветку
git add .
git commit -m "Описание изменений"
git push origin feature/my-feature

### 4. Создаем Pull Request (через веб-интерфейс GitHub)
### 5. Мержим PR (Squash and merge recommended)

### 6. Создаем тег (версию)
git checkout main
git pull origin main
git tag -a v1.1.0 -m "Добавлена новая функциональность"
git push origin v1.1.0

### 7. Удаляем ветку
git branch -d feature/my-feature
git push origin --delete feature/my-feature

## 📄 Лицензия
Этот проект лицензирован под MIT License. Вы можете свободно использовать, изменять и распространять код, при условии, что вы укажете автора.

Разрешенные действия:

   1. Использование кода в коммерческих и некоммерческих проектах
   2. Модификация кода
   3. Распространение кода

Обязательное условие: при использовании кода, пожалуйста, укажите ссылку на автора.

Developed with ❤️ by **DebugDestroy**  
[GitHub Profile](https://github.com/DebugDestroy)
