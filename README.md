# Typing Tutor
Minimalist command line typing tutor written in ruby

Installation:

```
$ gem install typingtutor
```

Show exercises available:

```
$ typingtutor 
```

Play a specific exercise, eg:

```
$ typingtutor biglebowski
```

![screenshot](https://dl.dropboxusercontent.com/u/28778231/typingtutor/demo.gif)

Generic training, generates 250 random english words

```
$ typingtutor training 
```

Improve on letters you struggle the most:

```
$ typingtutor improve
```

See overall stats about your typing:

```
$ typingtutor stats
ccuracy per letter:
6: 67%
7: 75%
9: 83%
m: 89%
b: 91%
w: 92%
j: 92%
y: 92%
h: 92%
n: 92%
...

Exercises:
- fox: 7 runs, 56 wpm
- improve: 3 runs, 36 wpm

Exercises played : 10
Time played: 17m 25s
Avg speed: 36 wpm
Max speed: 68 wpm

```
