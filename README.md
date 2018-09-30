# fidoosx
Installation guide for GoldEd on osx

### 1. Устанавливаем [Homebrew](https://brew.sh/index_ru)
```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### 2. Ставим [iTerm2](https://www.iterm2.com/downloads.html)
#### 2.1 Настариваем кодировку
  iTerm2 > Preferences > Profiles
  
  ![Preferences](https://sun1-15.userapi.com/c831208/v831208168/1abd71/L6Ohr9UqN9c.jpg)
  
  Жмем на плюсик, создаем новый профиль, называем его как хотим.
  
  ![New profile](https://pp.userapi.com/c848528/v848528168/8ba38/3KQry9Y9xt0.jpg)
  
  Там же, жмем на Other Actions... > Set as Default
  
  Открываем вкладку Terminal, ищем Character Encoding: ставим Cyrillic (KOI8-R)
  
  ![Character Encoding](https://pp.userapi.com/c848528/v848528919/8b33f/DYgnw4A5xXg.jpg)

### 3. Делаем клон репозитория
```sh
git clone https://github.com/dobrygin-als/fidoosx.git && cd fidoosx && cd fidoosxip
```
### 4. Запускаем установку сборки
```sh
sudo sh ./setup.sh
```

После выполения команды, он задаст вопросы для конфигурации сборки под ваш поинт. Первый вопрос будет таким:
```sh
-ne Enter your path to FidoOSX basedir [ /Users/$USER/fidoosx ]:
```
Важно оставить это поле пустым, просто нажав Enter. На все следующие вопросы ответы предоставит ваш сисоп

### 5. Проверяем необходимые пакеты для запуска GoldEd
Поочередно вбиваем команды:
```sh
  unrar
  unzip
  zip
```

Если вдруг какая-то команда выдает:

```sh
-bash: unrar: command not found
```

То, с помощью Homebrew устанвливаем недостающий пакет.

```sh
brew install unrar
```

### 5. Делаем Alias на GoldEd и отправку почты
```sh
  echo 'alias golded="sudo ~/fidoosx/geosx"' >> ~/.bash_profile
  echo 'alias fido="sudo ~/fidoosx/0.spsrtttl && sudo ~/fidoosx/send-recv"' >> ~/.bash_profile
  echo 'alias gldd="fido && golded"' >> ~/.bash_profile
```
После чего перезапускаем iTerm2.

### 6. Запускаем GoldEd через iTerm2
запустить редактор GoldEd
```sh
golded
```
отправить/забрать почту
```sh
fido
```
все два пункта выше вместе
```sh
gldd
```


