<h1>here is a bunch of really useful script</h1>

## the scripts :
- a fast gitmoji finder
- an extractor
- a project tester
- a src finder
- a proto finder
  
--- 


## fast gitmoji finder :
simply enter 
```bash
listgitmoji
```
and it will list you every gitmoji with the typical use or you can filter by typing
```bash
listgitmoji keywords
```
and you will see this : 
![image](https://github.com/user-attachments/assets/a7916384-f021-4bc2-9356-f1b06b3e4af4)

<br>
<br>

## the extractor :
simply by doing : 
```bash
extract file.zip
extract file.rar
extract file.tar.gz
...
```
the script will decide how to extract it, simplifies the life a lot


<br>
<br>

## the src finder : 
it will find every .c or .cpp file and they'r path used for Makefile to avoid illegal 
things like : src/*.c

![image](https://github.com/user-attachments/assets/76864c8d-5d8f-44af-8446-3257560e83af)

<br>
<br>

## the proto finder :
is used for c and c++ in h and hpp respectively 
it is used to remove the implicit declaration by going throught each file in every folder and subfolder
find every function and write in the console the proto of the function so you only have to copy paste it 
in your .h or .hpp file 

<br>
<br>

## the projtester :
you simply have to writer some tests on a file and run the test.sh 
it will execute a given binary and compare the output with the expected output and 
compare the return code with the expected one
