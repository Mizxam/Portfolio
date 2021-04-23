import keyboard
import os, time
import math


FRAMERATE = 20
DELTA_TIME = 1/FRAMERATE

height = 24
width = 80

screen = [[0 for x in range(width)] for y in range(height)]

PI = math.pi

reset_queue = False
score1,score2 = 0,0

def clear_screen(do_erase_all_char = False, debug_mode = False) -> None:
    if do_erase_all_char == True:
        global screen
        screen = [[0 for x in range(width)] for y in range(height)]
    
    if debug_mode:
        return

    if os.name == 'posix':
        os.system('clear')
    else:
        os.system('cls')

def print_screen() -> None:
    for y in screen:
        cache = ""
        for x in y:
            cache += '█' if x == 1 else ' '
        print(cache)

def draw_borders() -> None:
    for x in range(width):
        screen[0][x] = 1
        screen[height-1][x] = 1
    for y in range(height):
        screen[y][0] = 1
        screen[y][width-1] = 1

def score_point(speed_at_score:float) -> None:
    global score1,score2,reset_queue
    if speed_at_score > 0:
        score1 +=1
    else:
        score2 +=1
    reset_queue = True


class barrier:
    posy = 0
    posx = 0
    size = 0
    speed = 10
    b_length = 3
    char_up = ''
    char_down = ''
    def __init__(self, posx, char_up = 'w', char_down = 's', posy = height/2, size = 3, speed = 12) -> None:
        self.posy = posy
        self.posx = posx
        self.size = size
        self.speed = speed
        self.char_up = char_up
        self.char_down = char_down
        self.b_length = (self.size - 1)/2 + 1

    def act(self, delta) -> None:
        speed = self.speed
        b_length = self.b_length
        if keyboard.is_pressed(self.char_up):
            self.posy -= delta * speed if self.posy - b_length >= 1  else 0
        if keyboard.is_pressed(self.char_down):
            self.posy += delta * speed if self.posy + b_length < height - 1 else 0

    def shw(self):
        int_posy = int(self.posy)
        int_posx = int(self.posx)
        int_b_lenght = int(self.b_length)
        #print(int_b_lenght)
        for segment in range(int_b_lenght):
            screen[int_posy-segment][int_posx] = 1
            screen[int_posy+segment][int_posx] = 1



class ball:
    posy = 0
    posx = 0
    speed = 20
    speedx = 10
    speedy = 0
    def __init__(self, posx = width/2, posy = height/2, speed = 20):
        self.posy = posy
        self.posx = posx
        self.speedx = speed * math.cos(0)
        self.speedy = speed * math.sin(0)
    
    def act(self, delta) -> None:
        posy = self.posy
        posx = self.posx
        speed = self.speed
        speedy = self.speedy
        speedx = self.speedx
        
        bool_in_y = 0 < posy + delta * speedy < height-1
        bool_in_x = 0 < posx + delta * speedx < width-1
        self.posy += delta * speedy if bool_in_y else 0 
        self.posx += delta * speedx if bool_in_x else 0

        bounce_cache = False
        bool_in_border_y = posy + delta * speedy >= height-2 or posy + delta * speedy <= 2
        bool_in_border_x = posx + delta * speedx >= width-1 or posx + delta * speedx <= 1
        angle = math.atan2(speedy,speedx)
        print("angle",angle,"speedx",speedx,"speedy",speedy)
        if bool_in_border_y and not bounce_cache:
            print("in border y", posx,posy,angle)
            
            #self.speedy *= -1 #Simpler, but sucks!!
            #if angle <= 0: #Wrong answer!!
            #    self.speedy = speed*math.sin(angle + PI/2)/3
            #    self.speedx = speed*math.cos(angle + PI/2)
            #else:
            #    self.speedy = speed*math.sin(angle - PI/2)/3
            #    self.speedx = speed*math.cos(angle - PI/2)
            self.speedy = speed*math.sin(angle + PI/2 if speedx >= 0 else angle + PI/2)/3
            self.speedx = speed*math.cos(angle + PI/2 if speedx >= 0 else angle + PI/2)
            bounce_cache = True
        elif bounce_cache == False:
            bounce_cache = False
        
        if bool_in_border_x:
            score_point(speedx)
        

    def collide(self, delta, b:barrier):
        posy = self.posy
        posx = self.posx
        speed = self.speed
        #speedy = self.speedy
        speedx = self.speedx
        
        bounce_cache = False
        bool_in_y = b.posy - b.b_length <= posy <= b.posy + b.b_length
        bool_in_x = b.posx - 0.5 <= posx + delta * speedx <= b.posx + 0.5
        if bool_in_y and bool_in_x and bounce_cache == False:
            bounce_cache = True
            delta_y = b.posy - posy
            delta_x = b.posx - posx
            #angle = math.atan2(speedx,speedy)
            angle = math.atan2(delta_y,delta_x)
            self.speedy = speed*math.sin(angle+PI)/3
            self.speedx = speed*math.cos(angle+PI)
        
        else:
            bounce_cache = False
    
    def shw(self):
        int_posy = int(self.posy)
        int_posx = int(self.posx)
        screen[int_posy][int_posx] = 1



def do_barrier(b:barrier) -> None:
    b.act(DELTA_TIME)
    b.shw()

def do_ball(b:ball, barriers:[barrier]) -> None:
    b.act(DELTA_TIME)
    b.shw()
    for barrier in barriers:
        b.collide(DELTA_TIME,barrier)

def do_barriers(barriers:[barrier]) -> None:
    for barrier in barriers:
        do_barrier(barrier)

## -------------------- ## Start ## -------------------- ##

ball1 = ball()

barriers = [
    barrier(10,'w','s',height/2,5),
    barrier(width-11,'k','j',height/2,5)
]

def reset():
    global ball1,barriers,reset_queue
    ball1 = ball()
    barriers = [
        barrier(10,'w','s',height/2,5),
        barrier(width-11,'k','j',height/2,5)
    ]
    message = "Score :" + str(score1) + "|" + str(score2)
    input(message)
    reset_queue = False

while True:
    if reset_queue:
        reset()
    clear_screen(True,True)
    draw_borders()
    do_barriers(barriers)
    do_ball(ball1,barriers)
    print_screen()
    time.sleep(DELTA_TIME)