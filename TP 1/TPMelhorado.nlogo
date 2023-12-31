;globals[
;  verifica
;  verifica2
;]
; Células Castanhas -> Pequeno Porte
; Células Vermelhas -> Grande Porte
; Hienas -> Fish
; Leões -> Bug
breed [hienas hiena]
breed [lions lion]
breed [preys prey]
lions-own [
  sleep-timer
  energy
  ninho
]
hienas-own [
  energy
  group
]
preys-own [energy]


to setup
  clear-all
  ask patches [ ;;cria tabuleiro com a % de comida que o user definir
    ifelse random-float 100 < (comidaPequena) [
      set pcolor red ; 0% e 10% para as celulas vermelhas
    ] [
      ifelse random-float 100 < (comidaGrande) [
        set pcolor brown ; 0% e 20% para as celulas castanhas
      ] [
        set pcolor black
      ]
    ]
  ]

  ask n-of 5 patches ;;Cria 5 ninhos
  [ set pcolor blue ]

  setupLions
  setupHienas
  setuppreys

  reset-ticks
end

to setuppreys
  create-preys NrPresas [
    set color green
    set shape "circle"
    set size 1
    set energy EnergyPresas
    setxy random-xcor random-ycor
  ]
end

to setupLions
  create-lions quantLions [ ;;Cria leoes
    set color orange
    set shape "bug"
    set ninho 0; se for 1 está ao pé do ninho logo não pode morrer em combate nem perde energia / se for 0 tá fora do ninho.
    set size 1
    set energy energiaAgentes
    set sleep-timer 0
    setxy random-xcor random-ycor
  ]
end

to setupHienas
  create-hienas quantHienas [ ;;Cria hienas
    set color grey
    set shape "fish"
    set size 1
    set energy energiaAgentes
    setxy random-xcor random-ycor
    set group 1
    ; aquando da sua criação, os agentes do tipo hiena deverão receber um nível de agrupamento igual a 1
  ]
end

to go

  let total-patches count patches ;; conta total de patches
  let red-patches count patches with [pcolor = red] ;;conta total de patches vermelhas
  let red-percentage red-patches / total-patches * 100  ;;ve quantos pachtes vermelhos ha

  if red-percentage < comidaPequena [ ;;se for inferior a percentagem de comida referida pelo utilizado, ele da respawn
    let novaComida round((comidaPequena - red-percentage) / 100 * total-patches) ;;determina quanto sao precisos
    ask n-of novaComida patches with [pcolor != red] [
      set pcolor red
    ]
  ]

;  if not any? lions with [energy > 0] and verifica != 1 [
;    print (word "O último leão morreu no tick " ticks)
;    set verifica 1
;  ]
;
;  if not any? hienas with [energy > 0] and verifica2 != 1 [
;    print (word "A última hiena morreu no tick " ticks)
;    set verifica2 1
;  ]
;
;  if ticks = 500 [
;
;    if count lions != 0 [print(word "Leões Vivos: " count lions)]
;
;    if count hienas != 0 [print(word "Hienas Vivas: " count hienas)]
;
;    show("------")
;
;    stop
;  ]

  if count hienas = 0 and count lions = 0 [stop]

  ask turtles [
    ifelse energy <= 0 [ die ][
      if breed = lions [move_lions]
      if breed = hienas [move_hiennas]
      if breed = preys [move_presas]
    ]
  ]


  tick
end

to move_presas
  ask preys [
    let found 0
    let random-direction random 3
    let ahead-color [pcolor] of patch-ahead 1
    let ahead-patch patch-ahead 1
    let aNumHienas count hienas-on ahead-patch
    let aNumLions count lions-on ahead-patch

    if energy <= 0 [ die ]

    if (aNumHienas >= 1 and aNumLions >= 1) [
      set random-direction random 3

      if random-direction = 0 [
        left 90 ;; turn left by 90 degrees
        fd 1 ;; move forward
        set energy energy - 1
      ]
      if random-direction = 1 [
        left 90 ;; turn left by 90 degrees
        fd 1 ;; move forward
        set energy energy - 1
      ]
    ]

    if found = 0 [

      if random-direction = 0 [
        fd 1 ;; move forward
        set energy energy - 1
      ]
      if random-direction = 1 [
        left 90 ;; turn left by 90 degrees
        fd 1 ;; move forward
        set energy energy - 1
      ]
      if random-direction = 2 [
        right 90 ;; turn right by 90 degrees
        fd 1 ;; move forward
        set energy energy - 1
      ]
    ]
  ]
end

to move_lions
  ask lions [

    set ninho 0
    let found 0
    let sleep 0
    let random-direction random 3
    let left-destino patch-left-and-ahead 90 1
    let right-destino patch-right-and-ahead 90 1
    let ahead-destino patch-ahead 1

    let left-color [pcolor] of left-destino
    let right-color [pcolor] of right-destino
    let ahead-color [pcolor] of ahead-destino

    let lNumHienas count hienas-on left-destino
    let rNumHienas count hienas-on right-destino
    let aNumHienas count hienas-on ahead-destino

    let totalHienas lnumHienas + rNumHienas + aNumHienas


    (ifelse left-color = blue [ ; se encontrar célula azul na perceção, descansa.
      left 90
      fd 1
      set sleep-timer descansoLeao
      set ninho 1
    ] right-color = blue [
      right 90
      fd 1
      set sleep-timer descansoLeao
      set ninho 1
    ] ahead-color = blue [
      fd 1
      set ninho 1
      set sleep-timer descansoLeao
    ])

    if sleep-timer != 0 [
      set sleep-timer sleep-timer - 1
    ]

    if sleep-timer = 0[
      if (energy <= energiaAlimentacao) [
        ; se o nível de energia for inferior ao valor definido pelo utilizador
        ; Vai se alimentar primeiro, no caso de ter comida nas suas perceções
        ; Vai se movimentar em segundo

        let prey-ahead preys-on ahead-destino
        let prey-left preys-on left-destino
        let prey-right preys-on right-destino


        (ifelse pcolor = brown [  ; começa a prioridade alimentação

          set energy energy + comidaPequenaEnergy
          set pcolor black
          set found 1

        ] pcolor = red [

          set energy energy + comidaGrandeEnergy
          set pcolor black
          set found 1

        ] left-color != black [

          (ifelse left-color = brown [
            set energy energy + comidaGrandeEnergy
            ask patch-left-and-ahead 90 1 [set pcolor red]
          ] left-color = red [
            set energy energy + comidaPequenaEnergy
            ask patch-left-and-ahead 90 1 [set pcolor black]
          ])

          left 90
          forward 1
          set found 1
          set energy energy - 1

        ] right-color != black [

          (ifelse right-color = brown [
            set energy energy + comidaPequenaEnergy
            ask patch-right-and-ahead 90 1 [set pcolor red]
          ] right-color = red [
            set energy energy + comidaGrandeEnergy
            ask patch-right-and-ahead 90 1 [set pcolor black]
          ])

          right 90
          fd 1
          set found 1
          set energy energy - 1

        ] ahead-color != black [

          if ahead-color = brown [
            set energy energy + comidaPequenaEnergy
            ask patch-ahead 1 [set pcolor red]
          ]
          if ahead-color = red [
            set energy energy + comidaGrandeEnergy
            ask patch-ahead 1 [set pcolor black]
          ]

          forward 1
          set found 1
          set energy energy - 1

        ] any? prey-ahead or any? prey-left or any? prey-right [
          let target nobody
          (ifelse
            any? prey-ahead [ set target prey-ahead ]
            any? prey-left [ set target prey-left ]
            any? prey-right [ set target prey-right ]
          )

          if target != nobody [
            ask one-of target [die]
            set energy energy + EnergyPresas  ; LEAO MATOU PRESA
          ]
        ] totalHienas = 1 [
            set found 1
            let hiena-ahead one-of hienas-here  with [patch-here = ahead-destino]
            let hiena-left one-of hienas-here  with [patch-here = left-destino]
            let hiena-right one-of hienas-here  with [patch-here = right-destino]
            (ifelse hiena-ahead != nobody[

              let chance-vitoria random-float 1.0
              if chance-vitoria < 0.5 [
                set energy energy - ([energy] of hiena-ahead * (energiaCombateLeao / 100))
                set ahead-color brown
                ask hiena-ahead[die]
              ]

            ] hiena-left != nobody [

              let chance-vitoria random-float 1.0
              if chance-vitoria < 0.5 [
                set energy energy - ([energy] of hiena-left * (energiaCombateLeao / 100))
                set left-color brown
                ask hiena-left[die]

              ]
            ] hiena-right != nobody [
              let chance-vitoria random-float 1.0
              if chance-vitoria < 0.5 [
                set energy energy - ([energy] of hiena-right * (energiaCombateLeao / 100))
                set right-color brown
                ask hiena-right[die]
              ]
            ])
          ] lNumHienas >= 2 [
            right 90
            fd 1
            set found 1
            set energy energy - 2
          ] rNumHienas >= 2 [
            left 90
            fd 1
            set found 1
            set energy energy - 2
          ] aNumHienas >= 2 or (lNumHienas >= 1 and rNumHienas >= 1)[
            back 1
            set found 1
            set energy energy - 3
          ] lNumHienas >= 1 and aNumHienas >= 1 [
            rt 180  ; Vira o agente 180 graus para ele olhar para trás
            fd 1 ; Move o agente uma unidade para trás
            rt 90  ; Vira o agente 90 graus para a direita
            fd 1 ; Move o agente uma unidade para a direita
            set energy energy - 5
            set found 1
          ] lNumHienas >= 1 and rNumHienas >= 1 and aNumHienas >= 1 [
            back 2
            set found 1
            set energy energy - 4
        ])
      ]
      if found = 0  [
        if random-direction = 0 [
          fd 1  ;; move forward
          set energy energy - 1
        ]
        if random-direction = 1 [
          left 90  ;; turn left by 90 degrees
          fd 1  ;; move forward
          set energy energy - 1
        ]
        if random-direction = 2 [
          right 90  ;; turn right by 90 degrees
          fd 1  ;; move forward
          set energy energy - 1

        ]
      ]
    ]

    if energy <= 0 [die]

  ]

end

to move_hiennas
  ask hienas [
    let random-direction random 3
    let found 0
    set group 0
    let left-destino patch-left-and-ahead 90 1
    let right-destino patch-right-and-ahead 90 1
    let ahead-destino patch-ahead 1
    let left-color [pcolor] of left-destino
    let right-color [pcolor] of right-destino
    let ahead-color [pcolor] of ahead-destino

    let lNumHienas count hienas-on left-destino
    let rNumHienas count hienas-on right-destino
    let aNumHienas count hienas-on ahead-destino
    let tNumHienas lNumHienas + rNumHienas + aNumHienas

    let lNumLeoes count lions-on left-destino
    let rNumLeoes count lions-on right-destino
    let aNumLeoes count lions-on ahead-destino
    let tNumLeoes lNumLeoes + rNumLeoes + aNumLeoes

    let prey-ahead preys-on ahead-destino
    let prey-left preys-on left-destino
    let prey-right preys-on right-destino

    (ifelse tNumHienas > 0 [
      set color yellow
      set group tNumHienas + 1 ; o nº de hienas na vizinhança mais a própria
    ] tNumHienas = 0 [
      set color grey
      set group 1; só a própria
    ])

    if (energy <= energiaAlimentacao) [

      (ifelse pcolor = brown [  ; começa a prioridade alimentação

        set energy energy + comidaPequenaEnergy
        set pcolor black
        set found 1

      ] pcolor = red [

        set energy energy + comidaGrandeEnergy
        set pcolor black
        set found 1

      ] any? prey-ahead or any? prey-left or any? prey-right [
        let target nobody
        (ifelse
          any? prey-ahead [ set target prey-ahead ]
          any? prey-left [ set target prey-left ]
          any? prey-right [ set target prey-right ]
        )

        if target != nobody [
          ask one-of target [die]
          set energy energy + EnergyPresas  ; HIENA MATOU PRESA
        ]
      ] tNumHienas > 0 [

        if tNumLeoes = 1 [

          let leao-ahead one-of lions-here  with [patch-here = ahead-destino]
          let leao-left one-of lions-here  with [patch-here = left-destino]
          let leao-right one-of lions-here  with [patch-here = right-destino]

          (ifelse leao-left != nobody [
            let chance-vitoria random-float 1.0
            if chance-vitoria < 0.5 [
              set found 1
              let energiaPerder  [energy] of leao-left * (energiaCombateHiena / 100)
              set energy energy - (energiaPerder / group)
              ask leao-left[die]
            ]

          ] leao-right != nobody [
            let chance-vitoria random-float 1.0
            if chance-vitoria < 0.5 [
              set found 1
              let energiaPerder  [energy] of leao-right * (energiaCombateHiena / 100)
              set energy energy - (energiaPerder / group)
              ask leao-right[die]
            ]

          ] leao-ahead != nobody [
            let chance-vitoria random-float 1.0
            if chance-vitoria < 0.5 [
              set found 1
              let energiaPerder  [energy] of leao-ahead * (energiaCombateHiena / 100)
              set energy energy - (energiaPerder / group)
              ask leao-ahead[die]
            ]

          ])
        ]
      ])
    ]

    if found = 0  [
      (ifelse random-direction = 0 [

        if tNumHienas > 0 [

          let hiena-ahead one-of hienas-here  with [patch-here = ahead-destino]
          let hiena-left one-of hienas-here  with [patch-here = left-destino]
          let hiena-right one-of hienas-here  with [patch-here = right-destino]

          (ifelse
            hiena-left != nobody  [ask hiena-left  [fd 1 set energy energy - 1]]
            hiena-right != nobody [ask hiena-right [fd 1 set energy energy - 1]]
            hiena-ahead != nobody [ask hiena-ahead [fd 1 set energy energy - 1]]
          )
        ]

        fd 1  ;; move forward
        set energy energy - 1
      ] random-direction = 1 [

        if tNumHienas > 0 [

          let hiena-ahead one-of hienas-here  with [patch-here = ahead-destino]
          let hiena-left one-of hienas-here  with [patch-here = left-destino]
          let hiena-right one-of hienas-here  with [patch-here = right-destino]

          (ifelse
            hiena-left  != nobody [ask hiena-left  [left 90 fd 1 set energy energy - 1]]
            hiena-right != nobody [ask hiena-right [left 90 fd 1 set energy energy - 1]]
            hiena-ahead != nobody [ask hiena-ahead [left 90 fd 1 set energy energy - 1]]
          )
        ]

        left 90  ;; turn left by 90 degrees
        fd 1  ;; move forward
        set energy energy - 1

      ] random-direction = 2 [

        if tNumHienas > 0 [

          let hiena-ahead one-of hienas-here  with [patch-here = ahead-destino]
          let hiena-left one-of hienas-here  with [patch-here = left-destino]
          let hiena-right one-of hienas-here  with [patch-here = right-destino]

          (ifelse
            hiena-left != nobody [ask hiena-left  [right 90 fd 1 set energy energy - 1]]
            hiena-right != nobody [ask hiena-right [right 90 fd 1 set energy energy - 1]]
            hiena-ahead != nobody [ask hiena-ahead [right 90 fd 1 set energy energy - 1]]
          )
        ]

        right 90  ;; turn right by 90 degrees
        fd 1  ;; move forward
        set energy energy - 1

      ])
    ]

    if energy <= 0 [die]

  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
64
57
127
90
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
67
138
130
171
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
8
207
180
240
comidaPequena
comidaPequena
0
20
9.0
1
1
NIL
HORIZONTAL

SLIDER
7
282
179
315
comidaGrande
comidaGrande
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
16
355
188
388
quantLions
quantLions
0
50
22.0
1
1
NIL
HORIZONTAL

SLIDER
15
423
187
456
quantHienas
quantHienas
0
50
14.0
1
1
NIL
HORIZONTAL

SLIDER
729
87
901
120
comidaGrandeEnergy
comidaGrandeEnergy
0
50
25.0
1
1
NIL
HORIZONTAL

SLIDER
736
146
911
179
comidaPequenaEnergy
comidaPequenaEnergy
0
50
25.0
1
1
NIL
HORIZONTAL

INPUTBOX
25
516
180
576
energiaAgentes
100.0
1
0
Number

INPUTBOX
27
592
182
652
descansoLeao
5.0
1
0
Number

SLIDER
732
288
904
321
energiaAlimentacao
energiaAlimentacao
0
100
50.0
1
1
NIL
HORIZONTAL

PLOT
329
496
529
646
Quantidade de Leões & Hienas
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Leões" 1.0 0 -955883 true "" "plot count lions"
"Hienas" 1.0 0 -7500403 true "" "plot count hienas"

SLIDER
731
340
903
373
energiaCombateLeao
energiaCombateLeao
0
100
80.0
1
1
NIL
HORIZONTAL

SLIDER
731
394
903
427
energiaCombateHiena
energiaCombateHiena
0
100
60.0
1
1
NIL
HORIZONTAL

SLIDER
681
525
853
558
NrPresas
NrPresas
0
100
32.0
1
1
NIL
HORIZONTAL

SLIDER
686
588
858
621
EnergyPresas
EnergyPresas
0
100
72.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## Introdução do Trabalho Prático

O objetivo deste trabalho, com 2 valores de cotação, consiste em conceber, implementar e analisar comportamentos racionais para agentes reativos. O trabalho deve ser realizado na ferramenta NetLogo, onde num mundo (ou ambiente) habitam dois tipos de agentes. No ambiente existem células de diferentes espécies que concedem vantagens ou desvantagens aos agentes.

## Como funciona

No ambiente existe agentes leões e agentes hienas, onde que também existe comida e presas.

## Como usar

Slider "comidaPequena" -> Percentagem de Comida (pequena) que existe no ambiente
Slider "comidaGrande" -> Percentagem de Comida (pequena) que existe no ambiente
Slider "quantLions" -> Quantidade de Leões
Slider "quantHienas" -> Quantidade de Hienas
Entrada "energiaAgentes" -> Energia Inicial dos Agentes
Entrada "descansoLeao" -> Tempo de descanso do Leão quando percebe o ninho
Plot "Quantidade Leões & Hienas" -> Quantidade de leões e hienas (vivas)
Slider "comidaGrandeEnergy" -> Quantidade de energia que a comida grande dá ao agente (hiena ou leão)
Slider "comidaPequenaEnergy" ->  Quantidade de energia que a comida grande dá ao agente (hiena ou leão)
Slider "energiaAlimentacao" -> Energia que o agente leão precisa de ter (pelo menos) para fazer ações.
Slider "energiaCombateLeao" -> Percentagem que o Leão perde de energia em combate
Slider "energiaCombateHiena" -> Percentagem que o Hiena perde de energia em combate
Slider "NrPresas" -> Número de Presas
Slider "EnergyPresas" -> Energia das Presas

## Créditos

José Xavier a2021136585@isec.pt
Pedro Martins a2021118351@isec.pt
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
