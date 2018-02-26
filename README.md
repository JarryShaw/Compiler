# Compiler

> This repository maintains some assignments (projects / labs) during **Compiler** (SJTU).

&nbsp;

### Lexical Analysis

&emsp; Indicate a lexical analysis program using `Lex` language for `Python` sources. The program should be able to

- convert non-decimal numbers to decimal
- convert uppercase comments to lowercase

as the following example shows.

> The original file goes like this …

```python
#!/usr/bin/env python

'''Main  FUCTION'''   
def  main():
    a = (0o21 + 0x1c) * 2   # 0o21 equals 17
    b = 0b1001 * 0O37   # 0b1001 eqUALs 9
    c = 0XA1 - 55   # 0XA1 equals 161
    d = 0101   # 0101 EQUALS 65
    print a + b - c - d
'''END'''

if   __name__  ==  '__main__':
    """    
    CALL
    main function
    """
    main()  
```

> And afterwards, it should be like …

```python
#!/usr/bin/env python

'''main  fuction'''
def  main():
    a = (17 + 28) * 2   # 0o21 equals 17
    b = 9 * 31   # 0b1001 equals 9
    c = 161 - 55   # 0xa1 equals 161
    d = 65   # 0101 equals 65
    print a + b - c - d
'''end'''

if   __name__  ==  '__main__':
    """
    call
    main function
    """
    main()
```

&emsp; According to the requirements, the program should be run and tested with scripts bellow.

```bash
$ flex flex.l                   # > lex.yy.c
$ gcc lex.yy.c -lfl             # > a.out
$ ./a.out < test.py > result.py # in default
```

But due to some other reasons, the test sample and corresponding result are stored in `test` and `result`.
