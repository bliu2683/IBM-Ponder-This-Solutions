load 'plot'
directions =: _2 ]\ 1 2 2 1 2 _1 1 _2 _1 _2 _2 _1 _2 1 _1 2
NB. plot <"1 |: directions

NB. shoelace formula for area, see https://en.wikipedia.org/wiki/Shoelace_formula
fwd =: (+/)@:}:@:}.@:(*//.)@:(,{.)
area =: [:-:[:|fwd-[:fwd|.

NB. check intersection, see https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection#Given_two_points_on_each_line
det =: -/ . *
perm=: i.@! A. i.
itscl =: 4 : 0
num =. det ({. x-y) ,. (-/ y)
denom =. det (-/ x) ,. (-/y)
if. 0=denom do. NB. colinear or parallel
	if. 0 = >./ area"2 (perm 4) { x,y 	NB. x,y not necessarily ccw, check all 24 permutes
	do. chk =. (({.<./x)>.({.<./y))<:(({.>./x)<.({.>./y)) 	NB. colinear
	else. chk =. 0 end.				NB. parallel
else. chk =. 0 <: (0 1 _1) p. num % denom end.
chk
)
itscr =: 4 : 0
num =. det (-/ x) ,. ({. x-y)
denom =. det (-/ x) ,. (-/y)
if. 0=denom do. NB. colinear or parallel
	if. 0 = >./ area"2 (perm 4) { x,y 	NB. x,y not necessarily ccw, check all 24 permutes
	do. chk =. (({.<./x)>.({.<./y))<:(({.>./x)<.({.>./y)) 	NB. colinear
	else. chk =. 0 end.				NB. parallel
else. chk =. 0 <: (0 1 _1) p. - num % denom end.
chk
)
itsc =: itscl*.itscr

NB. 4 0 gennext 0 0, left arg only first number used
gennext =: ]+{&directions@:{.@:[
NB. genorder 4 5 6 7
genorder =: (gennext/\.&.|.)@:(,.&0)@:(0&,)

NB. (genorder 4 5 6) try 0
try =: 4 : 0
len =. <: # x
new =. (y, 0) gennext {: x
if. +./ (}: 2 ]\ x) itsc"2 ({:x) ,: new do. res =. 99
elseif. ((%: 5) * 14 - len) < (%: +/ *: new) do. res =. 99
elseif. 40 < */ >: (>./-<./) x , new do. res =. 99
elseif. do. res =. y end.
res
)

NB. grow 4 5 6
grow =: 3 : '(#~(99&~:@:{:)"1) y ,"1 0 (genorder y) try"_ 0 i.8'

NB. checklastcross 4 5 6
checklastcross =: 3 : 0
points =. genorder y
lastseg =. 0 ,:~ {: points
-. (+./) (}: }. 2]\ points) itsc"2 lastseg
)

NB. y is ''
valid =: 3 : 0
curr =: 1 1 $ 1
for_i. i.12 do.
	res =. 0$~0 ,2 + i
	for_row. curr do. res =. res, grow row end.
	curr =: res
end.
lastpoint =: ({:@:genorder)"1 curr
validend =: curr #~ lastpoint e. directions
notcross =: checklastcross"1 validend
final =: notcross # validend
areas =: (area@:genorder)"1 final
final /: areas
)

NB. result =: valid ''
NB. small =: {. result
NB. large =: _2 { result

num2lw =: ({&a.)@:(97&+)
num2od =: ":@:>:
NB. chessconv genorder 4 5 6
chessconv =: 3 : 0
std =. (-"1<./) y, 0 0
lw =. num2lw {. |: std
od =. ,num2od"0 {: |: std
, lw ,. od ,. ' '
)
NB. chessconv genorder small
NB. chessconv genorder large