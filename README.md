# portan-ignis
Компьютерная игра в жанре платформера с элементами головоломки для платформы PC (возможно портирование на Android в будущем). Действие игры разворачивается в абсолютно темном мире, игрок управляет персонажем, обладающим источником света, и должен избегать опасностей и преодолевать различные препятствия, таящиеся в темноте, чтобы продвинуться дальше. Одной из ключевых механик в игре является управление светом на уровнях для решения некоторых головоломок — например, некоторые враги реагируют на свет и возможным решением будет отвлечь их других источником света. 


Portan Ignis is a puzzle-platformer adventure game developed for PC (may be released for Android in the future). The game takes place in a completely dark world. The player controls a character with a light source (Ignis). He must overcome the different obstacles and keep out of dangers hidden in the dark for advancement by level. One of the key mechanics in the game is to control the light on the levels to solve some puzzles - for example, some enemies react to light and a possible solution would be to distract them with another light source.


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


# Правила названия веток
1. Всегда существует две ветки: "dev" (для разработки) и "master" (для промежуточных и финального релизов)
2. Временные ветки именуются на английском,с маленькой буквы, одно существительное или общепринятое сокращение понятное каждому


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
