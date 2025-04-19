#!/bin/bash

# Скрипт для автоматической компиляции и запуска программы с командным файлом

# 1. Компиляция программы
echo "🔧 Компиляция copy11.cpp..."
g++ -std=c++17 copy11.cpp -o terrain_navigator

if [ $? -ne 0 ]; then
    echo "❌ Ошибка компиляции!"
    exit 1
fi

# 2. Проверка существования командного файла
COMMAND_FILE="commands.txt"
if [ ! -f "$COMMAND_FILE" ]; then
    echo "❌ Файл команд $COMMAND_FILE не найден!"
    exit 1
fi

# 3. Запуск программы
echo "🚀 Запуск программы с командным файлом..."
echo -e "0\n$COMMAND_FILE" | ./terrain_navigator

# 4. Проверка результата выполнения
if [ $? -eq 0 ]; then
    echo "✅ Программа успешно завершена"
    echo "📁 Результаты сохранены в папке Result/"
else
    echo "❌ Программа завершилась с ошибкой"
fi
