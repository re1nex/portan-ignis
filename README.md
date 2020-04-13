# portan-ignis
Компьютерная игра в жанре платформер с элементами головоломки для платформы PC. Действие игры разворачивается в абсолютно темном,враждебном мире, хранящем в себе различные опасности. Главный герой, обладая источником света, должен преодолевать различные препятствия, чтобы продвинуться дальше. Одной из ключевых механик в игре является управление светом на уровнях для решения некоторых головоломок — например, некоторые враги реагируют на свет и возможным решением будет отвлечь их других источником света. 


Portan Ignis is a puzzle-platformer adventure game developed for PC. The game takes place in a completely dark world. The main character has an Ignis (light sourse). He must use it for overcome the different obstacles and keep out of dangers hidden in the dark. One of the key mechanics in the game is using the light on the levels to solve some puzzles. For example, the main character can distract some enemies using level's light source.


# Отличительные особенности
1.  Переносимость. Выбранный движок позволяет без особых сложностей портировать игру на другую платформу
2.  Необычный геймплей
3.  Лёгкая установка продукта  


# Системные требования и целевая платформа
1. Целевая платформа - PC
2. Системные требования:
   1. ОС: Windows 7 или новее
   2. Видеокарта: с поддержкой OpenGL 3 или лучше
   3. Минимальное разрешение: 1024 x 768
   4. Видеопамять: 512 мб или больше
   5. Оперативная память: 512 мб или больше


# Установка для разработчиков
1. Для установки вам понадобиться скачать [Godot Engine стандартная версия](https://godotengine.org/download/windows)

![alt text](https://github.com/re1nex/portan-ignis/blob/dev/instruction/godotWeb.png)

2. Распаковать архив с Godot Engine
3. Скачать архив с игрой из репозитория, для этого нужно будет выполнить команду ``` git clone https://github.com/re1nex/portan-ignis.git ``` в Git Bash
4. Распаковать архив с игрой
5. Запустите Godot Engine
6. Нажмите импорт и выберите расположение файлов игры

![alt text](https://github.com/re1nex/portan-ignis/blob/dev/instruction/godotImport.png)

7. Выберите файл project.godot (лежащий в основной директории проекта) и нажмите импорт
8. В открывшемся окне нажмите кнопку "Запустить проект"

![alt text](https://github.com/re1nex/portan-ignis/blob/dev/instruction/run.png)

# Установка для пользователей
1. Откройте вкладку [releases](https://github.com/re1nex/portan-ignis/releases)

![alt text](https://github.com/re1nex/portan-ignis/blob/dev/instruction/download.png)

2. Скачайте установщик из последнего релиза
3. Распакуйте скачанный архив и запустите setup.exe, лежащий внутри
4. Следуйте инструкциям внутри установщика
5. Для запуска игры можете использовать ярлык на рабочем столе (если он был создан) или Portan Ignis.exe в выбранной для установки папке 



# Правила комментирования коммитов
1. В начале комментариев указывается номер issuses, к которому он относится (в формате #номер)
2. После номера указывается одно из ключевых слов
- added 
- fixed 
- cut 

после которого ставится двоеточие
- В случае решения конфликтов по слиянию веток указывется ключевое слово merged, после которого "Название ветки источника" "Название ветки цели"
3. После, в виде ненумерованного списка ("-"), указывается, что конкретно было добавлено, исправлено или удалено
4. Точка в конце элемента списка не ставится
5. Если были выполнены разные действия (Например: добавление новых функций и исправление старых), то после одного списка ставится ключевое слово и пишется другой список

## Пример комментария:
```
#1 added:
- textures
fixed:
- problem with light 
```


# Правила создания и названия веток
1. Всегда существует две ветки: "dev" (для разработки) и "master" (для промежуточных и финального релизов)
2. Для каждой задачи, кроме документации, создается временная ветка
3. Временные ветки именуются на английском,с маленькой буквы, одно существительное или общепринятое сокращение понятное каждому


# Правила именования файлов и папок
1. Папки именуются с маленькой буквы
2. Файлы сцен и скриптов именуются с большой буквы, остальные файлы с маленькой


# Правила присвоения задаче label
1. Если задача связана с написанием правил, архитектуры, инструкции, описания и т.д. документации, то задаче присваивается label "documentation"
2. Если задача связана с исправлениями ошибок, то задаче присваивается label "fix"
3. Если задача связана с подбором или созданием текстур, то задаче присваивается label "textures"
4. Если задача связана с подбором или созданием анимаций, то задаче присваивается label "animation"
5. Если задача связана с небольшой модификацией уже имеющегося объекта или созданием тестового объекта, то задаче присваивается label "feature"
6. Если задача связана с большой модификацией (требующей достаточно большого количества времени) уже имеющегося объекта или же с созданием нового полноценного объекта, то задаче присваивается label "addition"



# Стандарт кодирования
[Руководство по стилю GDScript](https://docs.godotengine.org/ru/latest/getting_started/scripting/gdscript/gdscript_styleguide.html)


# Лицензия
Этот проект лицецнзирован в соответствии с [MIT License](https://github.com/re1nex/portan-ignis/blob/master/LICENSE)


# Команда разработки
1. [Александр Митенев](https://github.com/mitenevav)
2. [Никита Счастливцев](https://github.com/NikitaS4)
3. [Александр Карасев](https://github.com/MethaHardworker)
4. [Виктор Колесник](https://github.com/VsevolodMelnikov) - Техлид 
5. [Елисей Василевский](https://github.com/re1nex) - Тимлид 
