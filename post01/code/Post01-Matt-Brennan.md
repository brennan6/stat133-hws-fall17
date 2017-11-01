Post01-Matt-Brennan
================
Matt Brennan
10/29/2017

Hello fellow bloggers,

Introduction:

Today I am going to talk about one of the most useful packages in the R library, sqldf! Although the R language enables the programmer to perform various mathematical functions with data, there oftentimes is a disconnect between this language and various others. The primary reason for this divide is that most data analysts in businesses deal with relational database systems (RDBMS), where the R language fails to incorporate these systems.

Motivation:

The fix: the ambitious package sqldf!

Through this blog, I hope to not only demonstrate the effectiveness of this package, but captivate the reader into utilizing sqldf in future endeavors. The sqldf package allows one to use R but through SQL commands. Sprinkled throughout the blog will be examples, interesting facts, and descriptions of the actions that are being performed!

In order to install the package one must use the code below.

``` r
install.packages("sqldf", repos = "http://cran.rstudio.com/")
```

    ## 
    ## The downloaded binary packages are in
    ##  /var/folders/jc/8m831q3n2zlb73n7xs7r5s780000gn/T//RtmpDN2a9A/downloaded_packages

After the package is installed, one must library or load the package.

``` r
library(sqldf)
```

    ## Loading required package: gsubfn

    ## Loading required package: proto

    ## Warning in doTryCatch(return(expr), name, parentenv, handler): unable to load shared object '/Library/Frameworks/R.framework/Resources/modules//R_X11.so':
    ##   dlopen(/Library/Frameworks/R.framework/Resources/modules//R_X11.so, 6): Library not loaded: /opt/X11/lib/libSM.6.dylib
    ##   Referenced from: /Library/Frameworks/R.framework/Resources/modules//R_X11.so
    ##   Reason: image not found

    ## Could not load tcltk.  Will use slower R code instead.

    ## Loading required package: RSQLite

For the examples in this blog we will incoporate the stats of all nba players during the 2017 season. One can find this data in the data folder within post01.

``` r
github <- "https://github.com/ucb-stat133/stat133-fall-2017/raw/master/"
csv <- "data/nba2017-stats.csv"
download.file(url = paste0(github, csv), destfile = 'nba2017-stats.csv')
dat <- read.csv('nba2017-stats.csv', stringsAsFactors = FALSE)
```

``` r
dat
```

    ##                       player games_played minutes field_goals_made
    ## 1                 Al Horford           68    2193              379
    ## 2               Amir Johnson           80    1608              213
    ## 3              Avery Bradley           55    1835              359
    ## 4          Demetrius Jackson            5      17                3
    ## 5               Gerald Green           47     538               95
    ## 6              Isaiah Thomas           76    2569              682
    ## 7                Jae Crowder           72    2335              333
    ## 8                James Young           29     220               25
    ## 9               Jaylen Brown           78    1341              192
    ## 10             Jonas Jerebko           78    1232              114
    ## 11             Jordan Mickey           25     141               15
    ## 12              Kelly Olynyk           75    1538              260
    ## 13              Marcus Smart           79    2399              269
    ## 14              Terry Rozier           74    1263              151
    ## 15              Tyler Zeller           51     525               78
    ## 16             Channing Frye           74    1398              238
    ## 17             Dahntay Jones            1      12                3
    ## 18            Deron Williams           24     486               68
    ## 19          Derrick Williams           25     427               54
    ## 20               Edy Tavares            1      24                3
    ## 21             Iman Shumpert           76    1937              201
    ## 22                J.R. Smith           41    1187              123
    ## 23               James Jones           48     381               44
    ## 24                Kay Felder           42     386               62
    ## 25                Kevin Love           60    1885              370
    ## 26               Kyle Korver           35     859              131
    ## 27              Kyrie Irving           72    2525              671
    ## 28              LeBron James           74    2794              736
    ## 29         Richard Jefferson           79    1614              153
    ## 30          Tristan Thompson           78    2336              262
    ## 31             Bruno Caboclo            9      40                6
    ## 32               Cory Joseph           80    2003              299
    ## 33              Delon Wright           27     446               49
    ## 34             DeMar DeRozan           74    2620              721
    ## 35           DeMarre Carroll           72    1882              220
    ## 36             Fred VanVleet           37     294               39
    ## 37              Jakob Poeltl           54     626               67
    ## 38         Jonas Valanciunas           80    2066              391
    ## 39                Kyle Lowry           60    2244              426
    ## 40            Lucas Nogueira           57    1088              103
    ## 41             Norman Powell           76    1368              227
    ## 42               P.J. Tucker           24     609               52
    ## 43             Pascal Siakam           55     859              103
    ## 44         Patrick Patterson           65    1599              154
    ## 45               Serge Ibaka           23     712              128
    ## 46          Bojan Bogdanovic           26     601              107
    ## 47              Bradley Beal           77    2684              637
    ## 48          Brandon Jennings           23     374               29
    ## 49          Chris McCullough            2       8                0
    ## 50             Daniel Ochefu           19      75               12
    ## 51               Ian Mahinmi           31     555               65
    ## 52               Jason Smith           74    1068              174
    ## 53                 John Wall           78    2836              647
    ## 54             Marcin Gortat           82    2556              390
    ## 55           Markieff Morris           76    2374              406
    ## 56               Otto Porter           80    2605              414
    ## 57         Sheldon McClellan           30     287               30
    ## 58          Tomas Satoransky           57     719               61
    ## 59                Trey Burke           57     703              116
    ## 60           DeAndre' Bembry           38     371               47
    ## 61           Dennis Schroder           79    2485              548
    ## 62             Dwight Howard           74    2199              388
    ## 63            Ersan Ilyasova           26     633               93
    ## 64             Jose Calderon           17     247               23
    ## 65             Kent Bazemore           73    1963              295
    ## 66            Kris Humphries           56     689               87
    ## 67           Malcolm Delaney           73    1248              145
    ## 68             Mike Dunleavy           30     475               57
    ## 69              Mike Muscala           70    1237              170
    ## 70              Paul Millsap           69    2343              430
    ## 71                Ryan Kelly           16     110                8
    ## 72           Thabo Sefolosha           62    1596              174
    ## 73              Tim Hardaway           79    2154              415
    ## 74     Giannis Antetokounmpo           80    2845              656
    ## 75               Greg Monroe           81    1823              387
    ## 76             Jabari Parker           51    1728              399
    ## 77               Jason Terry           74    1365              105
    ## 78               John Henson           58    1123              159
    ## 79           Khris Middleton           29     889              150
    ## 80           Malcolm Brogdon           75    1982              290
    ## 81       Matthew Dellavedova           76    1986              208
    ## 82           Michael Beasley           56     935              216
    ## 83           Mirza Teletovic           70    1133              156
    ## 84             Rashad Vaughn           41     458               57
    ## 85             Spencer Hawes           19     171               30
    ## 86                Thon Maker           57     562               83
    ## 87                Tony Snell           80    2336              246
    ## 88              Aaron Brooks           65     894              121
    ## 89              Al Jefferson           66     931              235
    ## 90                C.J. Miles           76    1776              281
    ## 91             Georges Niang           23      93                9
    ## 92               Jeff Teague           82    2657              402
    ## 93                 Joe Young           33     135               26
    ## 94            Kevin Seraphin           49     559              109
    ## 95          Lance Stephenson            6     132               18
    ## 96               Lavoy Allen           61     871               77
    ## 97               Monta Ellis           74    1998              247
    ## 98              Myles Turner           81    2541              444
    ## 99               Paul George           75    2689              622
    ## 100         Rakeem Christmas           29     219               19
    ## 101           Thaddeus Young           74    2237              362
    ## 102           Anthony Morrow            9      87               12
    ## 103             Bobby Portis           64    1000              183
    ## 104            Cameron Payne           11     142               21
    ## 105        Cristiano Felicio           66    1040              128
    ## 106         Denzel Valentine           57     976              102
    ## 107              Dwyane Wade           60    1792              414
    ## 108            Isaiah Canaan           39     592               63
    ## 109             Jerian Grant           63    1028              128
    ## 110             Jimmy Butler           76    2809              570
    ## 111        Joffrey Lauvergne           20     241               37
    ## 112  Michael Carter-Williams           45     846              112
    ## 113           Nikola Mirotic           70    1679              258
    ## 114              Paul Zipser           44     843               88
    ## 115              Rajon Rondo           69    1843              229
    ## 116              Robin Lopez           81    2271              382
    ## 117             Dion Waiters           46    1384              281
    ## 118             Goran Dragic           73    2459              534
    ## 119         Hassan Whiteside           77    2513              542
    ## 120            James Johnson           76    2085              368
    ## 121           Josh McRoberts           22     381               44
    ## 122          Josh Richardson           53    1614              202
    ## 123          Justise Winslow           18     625               80
    ## 124             Luke Babbitt           68    1065              113
    ## 125              Okaro White           35     471               33
    ## 126          Rodney McGruder           78    1966              190
    ## 127            Tyler Johnson           73    2178              357
    ## 128            Udonis Haslem           17     130               11
    ## 129          Wayne Ellington           62    1500              231
    ## 130              Willie Reed           71    1031              162
    ## 131           Andre Drummond           81    2409              483
    ## 132              Aron Baynes           75    1163              143
    ## 133               Beno Udrih           39     560               92
    ## 134         Boban Marjanovic           35     293               72
    ## 135          Darrun Hilliard           39     381               47
    ## 136           Henry Ellenson           19     146               23
    ## 137                Ish Smith           81    1955              329
    ## 138                Jon Leuer           75    1944              310
    ## 139 Kentavious Caldwell-Pope           76    2529              370
    ## 140            Marcus Morris           79    2565              421
    ## 141          Michael Gbinije            9      32                1
    ## 142           Reggie Bullock           31     467               54
    ## 143           Reggie Jackson           52    1424              284
    ## 144          Stanley Johnson           77    1371              129
    ## 145            Tobias Harris           82    2567              511
    ## 146            Brian Roberts           41     416               46
    ## 147            Briante Weber           13     159               20
    ## 148           Christian Wood           13     107               12
    ## 149              Cody Zeller           62    1725              253
    ## 150           Frank Kaminsky           75    1954              320
    ## 151              Jeremy Lamb           62    1143              226
    ## 152          Johnny O'Bryant            4      34                8
    ## 153             Kemba Walker           79    2739              643
    ## 154          Marco Belinelli           74    1778              264
    ## 155          Marvin Williams           76    2295              297
    ## 156   Michael Kidd-Gilchrist           81    2349              295
    ## 157            Miles Plumlee           13     174               14
    ## 158            Nicolas Batum           77    2617              393
    ## 159           Ramon Sessions           50     811              100
    ## 160           Treveon Graham           27     189               19
    ## 161          Carmelo Anthony           74    2538              602
    ## 162           Chasson Randle           18     225               28
    ## 163             Courtney Lee           77    2459              321
    ## 164             Derrick Rose           64    2082              460
    ## 165              Joakim Noah           46    1015               99
    ## 166           Justin Holiday           82    1639              233
    ## 167       Kristaps Porzingis           66    2164              443
    ## 168             Kyle O'Quinn           79    1229              215
    ## 169             Lance Thomas           46     968               97
    ## 170         Marshall Plumlee           21     170               16
    ## 171            Maurice Ndour           32     331               39
    ## 172     Mindaugas Kuzminskas           68    1016              158
    ## 173                Ron Baker           52     857               82
    ## 174            Sasha Vujacic           42     408               42
    ## 175        Willy Hernangomez           72    1324              246
    ## 176             Aaron Gordon           80    2298              393
    ## 177          Bismack Biyombo           81    1793              179
    ## 178              C.J. Watson           62    1012               96
    ## 179            D.J. Augustin           78    1538              195
    ## 180             Damjan Rudez           45     314               31
    ## 181            Elfrid Payton           82    2412              430
    ## 182            Evan Fournier           68    2234              408
    ## 183               Jeff Green           69    1534              220
    ## 184              Jodie Meeks           36     738              103
    ## 185      Marcus Georges-Hunt            5      48                2
    ## 186            Mario Hezonja           65     960              117
    ## 187           Nikola Vucevic           75    2163              483
    ## 188          Patricio Garino            5      43                0
    ## 189        Stephen Zimmerman           19     108               10
    ## 190            Terrence Ross           24     748              115
    ## 191           Alex Poythress            6     157               25
    ## 192              Dario Saric           81    2129              381
    ## 193         Gerald Henderson           72    1667              234
    ## 194            Jahlil Okafor           50    1134              242
    ## 195           Jerryd Bayless            3      71               11
    ## 196              Joel Embiid           31     786              200
    ## 197          Justin Anderson           24     518               75
    ## 198             Nik Stauskas           80    2188              251
    ## 199           Richaun Holmes           57    1193              230
    ## 200         Robert Covington           67    2119              292
    ## 201         Sergio Rodriguez           68    1518              210
    ## 202               Shawn Long           18     234               61
    ## 203           T.J. McConnell           81    2133              236
    ## 204           Tiago Splitter            8      76               14
    ## 205  Timothe Luwawu-Cabarrot           69    1190              145
    ## 206         Andrew Nicholson           10     111               13
    ## 207           Archie Goodwin           12     184               34
    ## 208              Brook Lopez           75    2222              555
    ## 209             Caris LeVert           57    1237              171
    ## 210         Isaiah Whitehead           73    1643              204
    ## 211               Jeremy Lin           36     883              175
    ## 212               Joe Harris           52    1138              154
    ## 213          Justin Hamilton           64    1177              174
    ## 214           K.J. McDaniels           20     293               46
    ## 215               Quincy Acy           32     510               65
    ## 216               Randy Foye           69    1284              118
    ## 217  Rondae Hollis-Jefferson           78    1761              235
    ## 218          Sean Kilpatrick           70    1754              305
    ## 219        Spencer Dinwiddie           59    1334              134
    ## 220            Trevor Booker           71    1754              305
    ## 221           Andre Iguodala           76    1998              219
    ## 222             Damian Jones           10      85                8
    ## 223               David West           68     854              135
    ## 224           Draymond Green           76    2471              272
    ## 225                Ian Clark           77    1137              211
    ## 226     James Michael McAdoo           52     457               62
    ## 227             JaVale McGee           77     739              208
    ## 228             Kevin Durant           62    2070              551
    ## 229             Kevon Looney           53     447               56
    ## 230            Klay Thompson           78    2649              644
    ## 231              Matt Barnes           20     410               38
    ## 232            Patrick McCaw           71    1074              106
    ## 233         Shaun Livingston           76    1345              173
    ## 234            Stephen Curry           79    2638              675
    ## 235            Zaza Pachulia           70    1268              164
    ## 236              Bryn Forbes           36     285               36
    ## 237              Danny Green           68    1807              176
    ## 238                David Lee           79    1477              248
    ## 239            Davis Bertans           67     808              103
    ## 240          Dejounte Murray           38     322               50
    ## 241           Dewayne Dedmon           76    1330              161
    ## 242             Joel Anthony           19     122               10
    ## 243         Jonathon Simmons           78    1392              177
    ## 244            Kawhi Leonard           74    2474              636
    ## 245            Kyle Anderson           72    1020               93
    ## 246        LaMarcus Aldridge           72    2335              500
    ## 247            Manu Ginobili           69    1291              171
    ## 248              Patty Mills           80    1754              273
    ## 249                Pau Gasol           64    1627              303
    ## 250              Tony Parker           63    1587              265
    ## 251              Bobby Brown           25     123               23
    ## 252           Chinanu Onuaku            5      52                5
    ## 253             Clint Capela           65    1551              362
    ## 254              Eric Gordon           75    2323              412
    ## 255            Isaiah Taylor            4      52                1
    ## 256             James Harden           81    2947              674
    ## 257             Kyle Wiltjer           14      44                4
    ## 258             Lou Williams           23     591              102
    ## 259         Montrezl Harrell           58    1064              225
    ## 260         Patrick Beverley           67    2058              228
    ## 261            Ryan Anderson           72    2116              323
    ## 262               Sam Dekker           77    1419              203
    ## 263             Trevor Ariza           80    2773              326
    ## 264            Troy Williams            6     139               22
    ## 265            Alan Anderson           30     308               30
    ## 266            Austin Rivers           74    2054              323
    ## 267            Blake Griffin           61    2076              479
    ## 268             Brandon Bass           52     577              107
    ## 269            Brice Johnson            3       9                2
    ## 270               Chris Paul           61    1921              374
    ## 271           DeAndre Jordan           81    2570              412
    ## 272            Diamond Stone            7      24                3
    ## 273              J.J. Redick           78    2198              396
    ## 274           Jamal Crawford           82    2157              359
    ## 275         Luc Mbah a Moute           80    1787              191
    ## 276        Marreese Speights           82    1286              244
    ## 277              Paul Pierce           25     277               28
    ## 278           Raymond Felton           80    1700              221
    ## 279           Wesley Johnson           68     810               73
    ## 280               Alec Burks           42     653               99
    ## 281               Boris Diaw           73    1283              146
    ## 282               Dante Exum           66    1228              155
    ## 283           Derrick Favors           50    1186              203
    ## 284              George Hill           49    1544              289
    ## 285           Gordon Hayward           73    2516              545
    ## 286              Jeff Withey           51     432               55
    ## 287               Joe Ingles           82    1972              204
    ## 288              Joe Johnson           78    1843              273
    ## 289            Joel Bolomboy           12      53                9
    ## 290                Raul Neto           40     346               41
    ## 291              Rodney Hood           59    1593              272
    ## 292              Rudy Gobert           81    2744              413
    ## 293             Shelvin Mack           55    1205              170
    ## 294               Trey Lyles           71    1158              159
    ## 295             Alex Abrines           68    1055              134
    ## 296           Andre Roberson           79    2376              215
    ## 297         Domantas Sabonis           81    1632              192
    ## 298           Doug McDermott           22     430               56
    ## 299              Enes Kanter           72    1533              402
    ## 300             Jerami Grant           78    1490              146
    ## 301             Josh Huestis            2      31                6
    ## 302             Kyle Singler           32     385               34
    ## 303            Nick Collison           20     128               14
    ## 304              Norris Cole           13     125               16
    ## 305        Russell Westbrook           81    2802              824
    ## 306           Semaj Christon           64     973               77
    ## 307             Steven Adams           80    2389              374
    ## 308               Taj Gibson           23     487               89
    ## 309           Victor Oladipo           67    2222              412
    ## 310          Andrew Harrison           72    1474              117
    ## 311           Brandan Wright           28     447               83
    ## 312         Chandler Parsons           34     675               75
    ## 313            Deyonta Davis           36     238               24
    ## 314              James Ennis           64    1501              146
    ## 315           JaMychal Green           77    2101              250
    ## 316            Jarell Martin           42     558               58
    ## 317               Marc Gasol           74    2531              532
    ## 318              Mike Conley           69    2292              464
    ## 319               Tony Allen           71    1914              274
    ## 320             Troy Daniels           67    1183              185
    ## 321             Vince Carter           73    1799              193
    ## 322             Wade Baldwin           33     405               36
    ## 323             Wayne Selden           11     189               20
    ## 324            Zach Randolph           73    1786              433
    ## 325          Al-Farouq Aminu           61    1773              183
    ## 326             Allen Crabbe           79    2254              303
    ## 327            C.J. McCollum           80    2796              692
    ## 328           Damian Lillard           75    2694              661
    ## 329                 Ed Davis           46     789               75
    ## 330              Evan Turner           65    1658              235
    ## 331              Jake Layman           35     249               26
    ## 332             Jusuf Nurkic           20     584              120
    ## 333         Maurice Harkless           77    2223              314
    ## 334           Meyers Leonard           74    1222              146
    ## 335              Noah Vonleh           74    1265              130
    ## 336          Pat Connaughton           39     316               37
    ## 337           Shabazz Napier           53     512               73
    ## 338           Tim Quarterman           16      80               13
    ## 339         Danilo Gallinari           63    2134              335
    ## 340           Darrell Arthur           41     639               95
    ## 341          Emmanuel Mudiay           55    1406              208
    ## 342              Gary Harris           57    1782              320
    ## 343             Jamal Murray           82    1764              295
    ## 344            Jameer Nelson           75    2045              268
    ## 345         Juan Hernangomez           62     842              101
    ## 346           Kenneth Faried           61    1296              228
    ## 347            Malik Beasley           22     165               33
    ## 348            Mason Plumlee           27     632               99
    ## 349              Mike Miller           20     151                9
    ## 350             Nikola Jokic           73    2038              494
    ## 351              Roy Hibbert            6      11                2
    ## 352              Will Barton           60    1705              295
    ## 353          Wilson Chandler           71    2197              433
    ## 354            Alexis Ajinca           39     584               89
    ## 355            Anthony Davis           75    2708              770
    ## 356             Axel Toupane            2      41                5
    ## 357            Cheick Diallo           17     199               36
    ## 358         Dante Cunningham           66    1649              174
    ## 359         DeMarcus Cousins           17     574              142
    ## 360       Donatas Motiejunas           34     479               57
    ## 361            E'Twaun Moore           73    1820              283
    ## 362          Jordan Crawford           19     442              105
    ## 363             Jrue Holiday           67    2190              405
    ## 364                Omer Asik           31     482               31
    ## 365               Quinn Cook            9     111               22
    ## 366             Solomon Hill           80    2374              183
    ## 367              Tim Frazier           65    1525              163
    ## 368             A.J. Hammons           22     163               17
    ## 369          DeAndre Liggins            1      25                3
    ## 370             Devin Harris           65    1087              136
    ## 371            Dirk Nowitzki           54    1424              296
    ## 372      Dorian Finney-Smith           81    1642              124
    ## 373            Dwight Powell           77    1333              194
    ## 374          Harrison Barnes           79    2803              599
    ## 375               J.J. Barea           35     771              142
    ## 376            Jarrod Uthoff            9     115               16
    ## 377             Nerlens Noel           22     483               77
    ## 378         Nicolas Brussino           54     521               52
    ## 379              Salah Mejri           73     905               88
    ## 380               Seth Curry           70    2029              338
    ## 381          Wesley Matthews           73    2495              333
    ## 382             Yogi Ferrell           36    1046              142
    ## 383         Anthony Tolliver           65    1477              155
    ## 384            Arron Afflalo           61    1580              185
    ## 385             Ben McLemore           61    1176              180
    ## 386              Buddy Hield           25     727              142
    ## 387          Darren Collison           68    2063              340
    ## 388           Garrett Temple           65    1728              183
    ## 389     Georgios Papagiannis           22     355               56
    ## 390             Kosta Koufos           71    1419              216
    ## 391        Langston Galloway           19     375               42
    ## 392       Malachi Richardson           22     198               28
    ## 393                 Rudy Gay           30    1013              201
    ## 394          Skal Labissiere           33     612              117
    ## 395                Ty Lawson           69    1732              237
    ## 396             Tyreke Evans           14     314               59
    ## 397      Willie Cauley-Stein           75    1421              255
    ## 398            Adreian Payne           18     135               23
    ## 399           Andrew Wiggins           82    3048              709
    ## 400             Brandon Rush           47    1030               70
    ## 401             Cole Aldrich           62     531               45
    ## 402             Gorgui Dieng           82    2653              332
    ## 403              Jordan Hill            7      47                5
    ## 404       Karl-Anthony Towns           82    3030              802
    ## 405                Kris Dunn           78    1333              118
    ## 406          Nemanja Bjelica           65    1190              151
    ## 407              Omri Casspi           13     222               19
    ## 408              Ricky Rubio           75    2469              261
    ## 409         Shabazz Muhammad           78    1516              288
    ## 410               Tyus Jones           60     774               75
    ## 411              Zach LaVine           47    1749              326
    ## 412           Brandon Ingram           79    2279              276
    ## 413             Corey Brewer           24     358               53
    ## 414         D'Angelo Russell           63    1811              351
    ## 415              David Nwaba           20     397               47
    ## 416              Ivica Zubac           38     609              126
    ## 417          Jordan Clarkson           82    2397              477
    ## 418            Julius Randle           74    2132              377
    ## 419          Larry Nance Jr.           63    1442              190
    ## 420                Luol Deng           56    1486              164
    ## 421        Metta World Peace           25     160               19
    ## 422               Nick Young           60    1556              272
    ## 423              Tarik Black           67    1091              150
    ## 424          Thomas Robinson           48     560              105
    ## 425           Timofey Mozgov           54    1104              169
    ## 426              Tyler Ennis           22     392               65
    ## 427            Alan Williams           47     708              138
    ## 428                 Alex Len           77    1560              230
    ## 429           Brandon Knight           54    1140              209
    ## 430            Derrick Jones           32     545               68
    ## 431             Devin Booker           78    2730              606
    ## 432            Dragan Bender           43     574               57
    ## 433           Elijah Millsap            2      23                1
    ## 434             Eric Bledsoe           66    2176              449
    ## 435             Jared Dudley           64    1362              157
    ## 436          Leandro Barbosa           67     963              172
    ## 437          Marquese Chriss           82    1743              284
    ## 438             Ronnie Price           14     134                4
    ## 439              T.J. Warren           66    2048              403
    ## 440               Tyler Ulis           61    1123              184
    ## 441           Tyson Chandler           47    1298              153
    ##     field_goals_atts field_goals_perc points3_made points3_atts
    ## 1                801            0.473           86          242
    ## 2                370            0.576           27           66
    ## 3                775            0.463          108          277
    ## 4                  4            0.750            1            1
    ## 5                232            0.409           39          111
    ## 6               1473            0.463          245          646
    ## 7                720            0.463          157          394
    ## 8                 58            0.431           12           35
    ## 9                423            0.454           46          135
    ## 10               262            0.435           45          130
    ## 11                34            0.441            0            1
    ## 12               508            0.512           68          192
    ## 13               749            0.359           94          332
    ## 14               411            0.367           57          179
    ## 15               158            0.494            0            1
    ## 16               520            0.458          137          335
    ## 17                 8            0.375            0            2
    ## 18               147            0.463           22           53
    ## 19               107            0.505           21           52
    ## 20                 4            0.750            0            0
    ## 21               489            0.411           94          261
    ## 22               356            0.346           95          271
    ## 23                92            0.478           31           66
    ## 24               158            0.392            7           22
    ## 25               867            0.427          145          389
    ## 26               269            0.487           97          200
    ## 27              1420            0.473          177          441
    ## 28              1344            0.548          124          342
    ## 29               343            0.446           62          186
    ## 30               437            0.600            0            3
    ## 31                16            0.375            2            6
    ## 32               661            0.452           48          135
    ## 33               116            0.422           10           30
    ## 34              1545            0.467           33          124
    ## 35               549            0.401          109          320
    ## 36               111            0.351           11           29
    ## 37               115            0.583            0            0
    ## 38               702            0.557            1            2
    ## 39               918            0.464          193          468
    ## 40               156            0.660            3           12
    ## 41               506            0.449           56          173
    ## 42               128            0.406           24           60
    ## 43               205            0.502            1            7
    ## 44               384            0.401           94          253
    ## 45               279            0.459           41          103
    ## 46               234            0.457           45          115
    ## 47              1322            0.482          223          552
    ## 48               106            0.274           11           52
    ## 49                 1            0.000            0            1
    ## 50                27            0.444            0            0
    ## 51               111            0.586            0            0
    ## 52               329            0.529           37           78
    ## 53              1435            0.451           89          272
    ## 54               674            0.579            0            2
    ## 55               889            0.457           71          196
    ## 56               803            0.516          148          341
    ## 57                75            0.400            7           30
    ## 58               146            0.418            9           37
    ## 59               255            0.455           31           70
    ## 60                98            0.480            1           18
    ## 61              1215            0.451          100          294
    ## 62               613            0.633            0            2
    ## 63               226            0.412           32           92
    ## 64                57            0.404            8           30
    ## 65               721            0.409           92          266
    ## 66               214            0.407           19           54
    ## 67               388            0.374           26          110
    ## 68               130            0.438           33           77
    ## 69               337            0.504           46          110
    ## 70               972            0.442           75          241
    ## 71                28            0.286            4           10
    ## 72               395            0.441           41          120
    ## 73               912            0.455          149          417
    ## 74              1259            0.521           49          180
    ## 75               726            0.533            0            4
    ## 76               814            0.490           65          178
    ## 77               243            0.432           73          171
    ## 78               309            0.515            0            1
    ## 79               333            0.450           45          104
    ## 80               635            0.457           78          193
    ## 81               534            0.390           79          215
    ## 82               406            0.532           18           43
    ## 83               418            0.373          104          305
    ## 84               156            0.365           26           81
    ## 85                59            0.508            9           26
    ## 86               181            0.459           28           74
    ## 87               541            0.455          144          355
    ## 88               300            0.403           48          128
    ## 89               471            0.499            0            1
    ## 90               647            0.434          169          409
    ## 91                36            0.250            1           12
    ## 92               909            0.442           90          252
    ## 93                72            0.361            5           23
    ## 94               198            0.551            0            2
    ## 95                44            0.409            5            8
    ## 96               168            0.458            0            1
    ## 97               557            0.443           43          135
    ## 98               869            0.511           40          115
    ## 99              1349            0.461          195          496
    ## 100               43            0.442            0            0
    ## 101              687            0.527           45          118
    ## 102               29            0.414            6           14
    ## 103              375            0.488           32           96
    ## 104               63            0.333           11           34
    ## 105              222            0.577            0            0
    ## 106              288            0.354           73          208
    ## 107              955            0.434           45          145
    ## 108              173            0.364           25           94
    ## 109              301            0.425           49          134
    ## 110             1252            0.455           91          248
    ## 111               92            0.402            6           20
    ## 112              306            0.366           15           64
    ## 113              625            0.413          129          377
    ## 114              221            0.398           33           99
    ## 115              561            0.408           50          133
    ## 116              775            0.493            0            2
    ## 117              663            0.424           85          215
    ## 118             1124            0.475          117          289
    ## 119              973            0.557            0            0
    ## 120              769            0.479           87          256
    ## 121              118            0.373           13           31
    ## 122              513            0.394           75          227
    ## 123              225            0.356            7           35
    ## 124              281            0.402           87          210
    ## 125               87            0.379           12           34
    ## 126              460            0.413           73          220
    ## 127              824            0.433           93          250
    ## 128               23            0.478            0            3
    ## 129              555            0.416          149          394
    ## 130              285            0.568            1            4
    ## 131              911            0.530            2            7
    ## 132              279            0.513            0            0
    ## 133              197            0.467           11           32
    ## 134              132            0.545            0            0
    ## 135              126            0.373           12           46
    ## 136               64            0.359           10           35
    ## 137              749            0.439           28          105
    ## 138              646            0.480           49          167
    ## 139              928            0.399          153          437
    ## 140             1007            0.418          118          357
    ## 141               10            0.100            0            4
    ## 142              128            0.422           28           73
    ## 143              677            0.419           66          184
    ## 144              365            0.353           45          154
    ## 145             1063            0.481          109          314
    ## 146              122            0.377           17           44
    ## 147               46            0.435            1            7
    ## 148               23            0.522            0            5
    ## 149              443            0.571            0            1
    ## 150              802            0.399          116          354
    ## 151              491            0.460           41          146
    ## 152               15            0.533            1            3
    ## 153             1449            0.444          240          602
    ## 154              615            0.429          102          283
    ## 155              704            0.422          124          354
    ## 156              618            0.477            1            9
    ## 157               24            0.583            0            0
    ## 158              975            0.403          135          405
    ## 159              263            0.380           21           62
    ## 160               40            0.475            9           15
    ## 161             1389            0.433          151          421
    ## 162               72            0.389           10           32
    ## 163              704            0.456          108          269
    ## 164              977            0.471           13           60
    ## 165              201            0.493            0            1
    ## 166              538            0.433           97          273
    ## 167              985            0.450          112          314
    ## 168              413            0.521            2           17
    ## 169              244            0.398           38           85
    ## 170               30            0.533            0            0
    ## 171               86            0.453            1            7
    ## 172              369            0.428           54          168
    ## 173              217            0.378           23           86
    ## 174              136            0.309           23           74
    ## 175              465            0.529            4           15
    ## 176              865            0.454           77          267
    ## 177              339            0.528            0            0
    ## 178              248            0.387           32          105
    ## 179              517            0.377           95          274
    ## 180               88            0.352           20           64
    ## 181              912            0.471           40          146
    ## 182              930            0.439          128          360
    ## 183              558            0.394           53          193
    ## 184              256            0.402           56          137
    ## 185                7            0.286            1            2
    ## 186              330            0.355           43          144
    ## 187             1031            0.468           23           75
    ## 188                7            0.000            0            5
    ## 189               31            0.323            0            0
    ## 190              267            0.431           46          135
    ## 191               54            0.463            6           19
    ## 192              927            0.411          106          341
    ## 193              553            0.423           61          173
    ## 194              471            0.514            0            0
    ## 195               32            0.344            2            5
    ## 196              429            0.466           36           98
    ## 197              162            0.463           21           72
    ## 198              634            0.396          132          359
    ## 199              412            0.558           27           77
    ## 200              732            0.399          137          412
    ## 201              536            0.392           92          252
    ## 202              109            0.560            7           19
    ## 203              512            0.461           11           55
    ## 204               31            0.452            2            6
    ## 205              361            0.402           50          161
    ## 206               34            0.382            2           11
    ## 207               61            0.557            4           13
    ## 208             1172            0.474          134          387
    ## 209              380            0.450           59          184
    ## 210              508            0.402           44          149
    ## 211              400            0.438           58          156
    ## 212              362            0.425           85          221
    ## 213              379            0.459           55          181
    ## 214              101            0.455           11           39
    ## 215              153            0.425           36           83
    ## 216              325            0.363           67          203
    ## 217              542            0.434           15           67
    ## 218              735            0.415          105          308
    ## 219              302            0.444           38          101
    ## 220              591            0.516           25           78
    ## 221              415            0.528           64          177
    ## 222               16            0.500            0            0
    ## 223              252            0.536            3            8
    ## 224              650            0.418           81          263
    ## 225              433            0.487           61          163
    ## 226              117            0.530            2            8
    ## 227              319            0.652            0            4
    ## 228             1026            0.537          117          312
    ## 229              107            0.523            2            9
    ## 230             1376            0.468          268          647
    ## 231               90            0.422           18           52
    ## 232              245            0.433           41          123
    ## 233              316            0.547            1            3
    ## 234             1443            0.468          324          789
    ## 235              307            0.534            0            2
    ## 236               99            0.364           17           53
    ## 237              449            0.392          118          311
    ## 238              420            0.590            0            0
    ## 239              234            0.440           69          173
    ## 240              116            0.431            9           23
    ## 241              259            0.622            0            0
    ## 242               16            0.625            0            0
    ## 243              421            0.420           30          102
    ## 244             1311            0.485          147          386
    ## 245              209            0.445           15           40
    ## 246             1049            0.477           23           56
    ## 247              439            0.390           89          227
    ## 248              622            0.439          147          356
    ## 249              604            0.502           56          104
    ## 250              569            0.466           23           69
    ## 251               60            0.383           14           35
    ## 252                7            0.714            0            0
    ## 253              563            0.643            0            0
    ## 254             1016            0.406          246          661
    ## 255                7            0.143            0            2
    ## 256             1533            0.440          262          756
    ## 257               14            0.286            4           13
    ## 258              264            0.386           41          129
    ## 259              345            0.652            1            7
    ## 260              543            0.420          110          288
    ## 261              773            0.418          204          506
    ## 262              429            0.473           60          187
    ## 263              798            0.409          191          555
    ## 264               44            0.500            8           21
    ## 265               80            0.375           14           44
    ## 266              731            0.442          111          299
    ## 267              971            0.493           38          113
    ## 268              186            0.575            1            3
    ## 269                7            0.286            0            0
    ## 270              785            0.476          124          302
    ## 271              577            0.714            0            2
    ## 272               13            0.231            0            0
    ## 273              890            0.445          201          468
    ## 274              869            0.413          116          322
    ## 275              378            0.505           43          110
    ## 276              548            0.445          103          277
    ## 277               70            0.400           15           43
    ## 278              514            0.430           46          144
    ## 279              200            0.365           29          118
    ## 280              248            0.399           25           76
    ## 281              327            0.446           20           81
    ## 282              364            0.426           44          149
    ## 283              417            0.487            3           10
    ## 284              606            0.477           94          233
    ## 285             1156            0.471          149          374
    ## 286              103            0.534            0            1
    ## 287              451            0.452          123          279
    ## 288              626            0.436          106          258
    ## 289               16            0.563            1            4
    ## 290               91            0.451           10           31
    ## 291              666            0.408          114          306
    ## 292              623            0.663            0            1
    ## 293              381            0.446           37          120
    ## 294              439            0.362           65          204
    ## 295              341            0.393           94          247
    ## 296              463            0.464           45          184
    ## 297              481            0.399           51          159
    ## 298              124            0.452           21           58
    ## 299              737            0.545            5           38
    ## 300              311            0.469           43          114
    ## 301               11            0.545            2            4
    ## 302               83            0.410            7           37
    ## 303               23            0.609            0            1
    ## 304               52            0.308            3           13
    ## 305             1941            0.425          200          583
    ## 306              223            0.345           12           63
    ## 307              655            0.571            0            1
    ## 308              179            0.497            1            1
    ## 309              932            0.442          127          352
    ## 310              360            0.325           43          156
    ## 311              135            0.615            0            1
    ## 312              222            0.338           25           93
    ## 313               47            0.511            0            0
    ## 314              321            0.455           51          137
    ## 315              500            0.500           55          145
    ## 316              151            0.384            9           25
    ## 317             1160            0.459          104          268
    ## 318             1009            0.460          171          419
    ## 319              595            0.461           15           54
    ## 320              495            0.374          138          355
    ## 321              490            0.394          112          296
    ## 322              115            0.313            3           22
    ## 323               50            0.400            3           21
    ## 324              964            0.449           21           94
    ## 325              466            0.393           70          212
    ## 326              647            0.468          134          302
    ## 327             1441            0.480          185          440
    ## 328             1488            0.444          214          578
    ## 329              142            0.528            0            0
    ## 330              552            0.426           31          118
    ## 331               89            0.292           13           51
    ## 332              236            0.508            0            1
    ## 333              624            0.503           68          194
    ## 334              378            0.386           74          213
    ## 335              270            0.481            7           20
    ## 336               72            0.514           17           33
    ## 337              183            0.399           34           92
    ## 338               29            0.448            5           13
    ## 339              750            0.447          126          325
    ## 340              215            0.442           53          117
    ## 341              551            0.377           56          177
    ## 342              636            0.503          107          255
    ## 343              729            0.405          115          344
    ## 344              604            0.444          106          273
    ## 345              223            0.453           46          112
    ## 346              415            0.549            0            6
    ## 347               73            0.452            9           28
    ## 348              181            0.547            0            1
    ## 349               23            0.391            8           20
    ## 350              856            0.577           45          139
    ## 351                3            0.667            0            0
    ## 352              667            0.442           87          235
    ## 353              940            0.461          110          326
    ## 354              178            0.500            0            4
    ## 355             1527            0.504           40          134
    ## 356                8            0.625            1            3
    ## 357               76            0.474            0            0
    ## 358              359            0.485           71          181
    ## 359              314            0.452           36           96
    ## 360              138            0.413           11           47
    ## 361              619            0.457           77          208
    ## 362              218            0.482           37           95
    ## 363              894            0.453          100          281
    ## 364               65            0.477            0            0
    ## 365               41            0.537            6           12
    ## 366              477            0.384           94          270
    ## 367              404            0.403           40          128
    ## 368               42            0.405            5           10
    ## 369                6            0.500            0            1
    ## 370              341            0.399           58          177
    ## 371              678            0.437           79          209
    ## 372              333            0.372           56          191
    ## 373              377            0.515           21           74
    ## 374             1280            0.468           78          222
    ## 375              343            0.414           53          148
    ## 376               38            0.421            3            9
    ## 377              134            0.575            0            0
    ## 378              141            0.369           29           95
    ## 379              137            0.642            1            3
    ## 380              703            0.481          137          322
    ## 381              847            0.393          174          479
    ## 382              345            0.412           60          149
    ## 383              351            0.442           90          230
    ## 384              420            0.440           62          151
    ## 385              419            0.430           65          170
    ## 386              296            0.480           59          138
    ## 387              714            0.476           73          175
    ## 388              432            0.424           82          220
    ## 389              102            0.549            0            2
    ## 390              392            0.551            0            1
    ## 391              104            0.404           19           40
    ## 392               68            0.412            8           28
    ## 393              442            0.455           42          113
    ## 394              218            0.537            3            8
    ## 395              522            0.454           34          118
    ## 396              143            0.413           21           48
    ## 397              481            0.530            0            2
    ## 398               54            0.426            3           15
    ## 399             1570            0.452          103          289
    ## 400              187            0.374           44          114
    ## 401               86            0.523            0            0
    ## 402              661            0.502           16           43
    ## 403               13            0.385            0            0
    ## 404             1479            0.542          101          275
    ## 405              313            0.377           21           73
    ## 406              356            0.424           56          177
    ## 407               39            0.487            2           10
    ## 408              650            0.402           60          196
    ## 409              598            0.482           49          146
    ## 410              181            0.414           26           73
    ## 411              710            0.459          120          310
    ## 412              686            0.402           55          187
    ## 413              121            0.438            5           24
    ## 414              867            0.405          135          384
    ## 415               81            0.580            1            5
    ## 416              238            0.529            0            3
    ## 417             1071            0.445          117          356
    ## 418              773            0.488           17           63
    ## 419              361            0.526           10           36
    ## 420              424            0.387           51          165
    ## 421               68            0.279            9           38
    ## 422              633            0.430          170          421
    ## 423              294            0.510            1            2
    ## 424              196            0.536            0            1
    ## 425              328            0.515            0            1
    ## 426              144            0.451           21           54
    ## 427              267            0.517            0            1
    ## 428              463            0.497            3           12
    ## 429              525            0.398           45          139
    ## 430              121            0.562            3           11
    ## 431             1431            0.423          147          405
    ## 432              161            0.354           28          101
    ## 433                7            0.143            0            2
    ## 434             1034            0.434          104          310
    ## 435              346            0.454           77          203
    ## 436              392            0.439           35           98
    ## 437              632            0.449           72          224
    ## 438               24            0.167            3           17
    ## 439              814            0.495           26           98
    ## 440              437            0.421           21           79
    ## 441              228            0.671            0            0
    ##     points3_perc points2_made points2_atts points2_perc points1_made
    ## 1          0.355          293          559        0.524          108
    ## 2          0.409          186          304        0.612           67
    ## 3          0.390          251          498        0.504           68
    ## 4          1.000            2            3        0.667            3
    ## 5          0.351           56          121        0.463           33
    ## 6          0.379          437          827        0.528          590
    ## 7          0.398          176          326        0.540          176
    ## 8          0.343           13           23        0.565            6
    ## 9          0.341          146          288        0.507           85
    ## 10         0.346           69          132        0.523           26
    ## 11         0.000           15           33        0.455            8
    ## 12         0.354          192          316        0.608           90
    ## 13         0.283          175          417        0.420          203
    ## 14         0.318           94          232        0.405           51
    ## 15         0.000           78          157        0.497           22
    ## 16         0.409          101          185        0.546           63
    ## 17         0.000            3            6        0.500            3
    ## 18         0.415           46           94        0.489           21
    ## 19         0.404           33           55        0.600           27
    ## 20            NA            3            4        0.750            0
    ## 21         0.360          107          228        0.469           71
    ## 22         0.351           28           85        0.329           10
    ## 23         0.470           13           26        0.500           13
    ## 24         0.318           55          136        0.404           35
    ## 25         0.373          225          478        0.471          257
    ## 26         0.485           34           69        0.493           14
    ## 27         0.401          494          979        0.505          297
    ## 28         0.363          612         1002        0.611          358
    ## 29         0.333           91          157        0.580           80
    ## 30         0.000          262          434        0.604          106
    ## 31         0.333            4           10        0.400            0
    ## 32         0.356          251          526        0.477           94
    ## 33         0.333           39           86        0.453           42
    ## 34         0.266          688         1421        0.484          545
    ## 35         0.341          111          229        0.485           89
    ## 36         0.379           28           82        0.341           18
    ## 37            NA           67          115        0.583           31
    ## 38         0.500          390          700        0.557          176
    ## 39         0.412          233          450        0.518          299
    ## 40         0.250          100          144        0.694           44
    ## 41         0.324          171          333        0.514          126
    ## 42         0.400           28           68        0.412           11
    ## 43         0.143          102          198        0.515           22
    ## 44         0.372           60          131        0.458           43
    ## 45         0.398           87          176        0.494           30
    ## 46         0.391           62          119        0.521           71
    ## 47         0.404          414          770        0.538          282
    ## 48         0.212           18           54        0.333           12
    ## 49         0.000            0            0           NA            1
    ## 50            NA           12           27        0.444            0
    ## 51            NA           65          111        0.586           43
    ## 52         0.474          137          251        0.546           35
    ## 53         0.327          558         1163        0.480          422
    ## 54         0.000          390          672        0.580          103
    ## 55         0.362          335          693        0.483          180
    ## 56         0.434          266          462        0.576           99
    ## 57         0.233           23           45        0.511           23
    ## 58         0.243           52          109        0.477           23
    ## 59         0.443           85          185        0.459           22
    ## 60         0.056           46           80        0.575            6
    ## 61         0.340          448          921        0.486          218
    ## 62         0.000          388          611        0.635          226
    ## 63         0.348           61          134        0.455           52
    ## 64         0.267           15           27        0.556            7
    ## 65         0.346          203          455        0.446          119
    ## 66         0.352           68          160        0.425           64
    ## 67         0.236          119          278        0.428           75
    ## 68         0.429           24           53        0.453           22
    ## 69         0.418          124          227        0.546           49
    ## 70         0.311          355          731        0.486          311
    ## 71         0.400            4           18        0.222            5
    ## 72         0.342          133          275        0.484           55
    ## 73         0.357          266          495        0.537          164
    ## 74         0.272          607         1079        0.563          471
    ## 75         0.000          387          722        0.536          177
    ## 76         0.365          334          636        0.525          162
    ## 77         0.427           32           72        0.444           24
    ## 78         0.000          159          308        0.516           74
    ## 79         0.433          105          229        0.459           81
    ## 80         0.404          212          442        0.480          109
    ## 81         0.367          129          319        0.404           82
    ## 82         0.419          198          363        0.545           78
    ## 83         0.341           52          113        0.460           35
    ## 84         0.321           31           75        0.413            2
    ## 85         0.346           21           33        0.636           14
    ## 86         0.378           55          107        0.514           32
    ## 87         0.406          102          186        0.548           47
    ## 88         0.375           73          172        0.424           32
    ## 89         0.000          235          470        0.500           65
    ## 90         0.413          112          238        0.471           84
    ## 91         0.083            8           24        0.333            2
    ## 92         0.357          312          657        0.475          360
    ## 93         0.217           21           49        0.429           11
    ## 94         0.000          109          196        0.556           14
    ## 95         0.625           13           36        0.361            2
    ## 96         0.000           77          167        0.461           23
    ## 97         0.319          204          422        0.483           93
    ## 98         0.348          404          754        0.536          245
    ## 99         0.393          427          853        0.501          336
    ## 100           NA           19           43        0.442           21
    ## 101        0.381          317          569        0.557           45
    ## 102        0.429            6           15        0.400           11
    ## 103        0.333          151          279        0.541           39
    ## 104        0.324           10           29        0.345            1
    ## 105           NA          128          222        0.577           60
    ## 106        0.351           29           80        0.363           14
    ## 107        0.310          369          810        0.456          223
    ## 108        0.266           38           79        0.481           30
    ## 109        0.366           79          167        0.473           65
    ## 110        0.367          479         1004        0.477          585
    ## 111        0.300           31           72        0.431            9
    ## 112        0.234           97          242        0.401           58
    ## 113        0.342          129          248        0.520           99
    ## 114        0.333           55          122        0.451           31
    ## 115        0.376          179          428        0.418           30
    ## 116        0.000          382          773        0.494           75
    ## 117        0.395          196          448        0.438           82
    ## 118        0.405          417          835        0.499          298
    ## 119           NA          542          973        0.557          225
    ## 120        0.340          281          513        0.548          152
    ## 121        0.419           31           87        0.356            6
    ## 122        0.330          127          286        0.444           60
    ## 123        0.200           73          190        0.384           29
    ## 124        0.414           26           71        0.366           11
    ## 125        0.353           21           53        0.396           20
    ## 126        0.332          117          240        0.488           44
    ## 127        0.372          264          574        0.460          195
    ## 128        0.000           11           20        0.550            9
    ## 129        0.378           82          161        0.509           37
    ## 130        0.250          161          281        0.573           49
    ## 131        0.286          481          904        0.532          137
    ## 132           NA          143          279        0.513           79
    ## 133        0.344           81          165        0.491           32
    ## 134           NA           72          132        0.545           47
    ## 135        0.261           35           80        0.438           21
    ## 136        0.286           13           29        0.448            4
    ## 137        0.267          301          644        0.467           72
    ## 138        0.293          261          479        0.545           98
    ## 139        0.350          217          491        0.442          154
    ## 140        0.331          303          650        0.466          145
    ## 141        0.000            1            6        0.167            2
    ## 142        0.384           26           55        0.473            5
    ## 143        0.359          218          493        0.442          118
    ## 144        0.292           84          211        0.398           36
    ## 145        0.347          402          749        0.537          190
    ## 146        0.386           29           78        0.372           33
    ## 147        0.143           19           39        0.487            9
    ## 148        0.000           12           18        0.667           11
    ## 149        0.000          253          442        0.572          133
    ## 150        0.328          204          448        0.455          118
    ## 151        0.281          185          345        0.536          110
    ## 152        0.333            7           12        0.583            1
    ## 153        0.399          403          847        0.476          304
    ## 154        0.360          162          332        0.488          150
    ## 155        0.350          173          350        0.494          131
    ## 156        0.111          294          609        0.483          152
    ## 157           NA           14           24        0.583            3
    ## 158        0.333          258          570        0.453          243
    ## 159        0.339           79          201        0.393           91
    ## 160        0.600           10           25        0.400           10
    ## 161        0.359          451          968        0.466          304
    ## 162        0.313           18           40        0.450           29
    ## 163        0.401          213          435        0.490           85
    ## 164        0.217          447          917        0.487          221
    ## 165        0.000           99          200        0.495           34
    ## 166        0.355          136          265        0.513           66
    ## 167        0.357          331          671        0.493          198
    ## 168        0.118          213          396        0.538           64
    ## 169        0.447           59          159        0.371           43
    ## 170           NA           16           30        0.533            8
    ## 171        0.143           38           79        0.481           19
    ## 172        0.321          104          201        0.517           55
    ## 173        0.267           59          131        0.450           28
    ## 174        0.311           19           62        0.306           17
    ## 175        0.267          242          450        0.538           91
    ## 176        0.288          316          598        0.528          156
    ## 177           NA          179          339        0.528          125
    ## 178        0.305           64          143        0.448           57
    ## 179        0.347          100          243        0.412          131
    ## 180        0.313           11           24        0.458            0
    ## 181        0.274          390          766        0.509          146
    ## 182        0.356          280          570        0.491          223
    ## 183        0.275          167          365        0.458          145
    ## 184        0.409           47          119        0.395           65
    ## 185        0.500            1            5        0.200            9
    ## 186        0.299           74          186        0.398           40
    ## 187        0.307          460          956        0.481          107
    ## 188        0.000            0            2        0.000            0
    ## 189           NA           10           31        0.323            3
    ## 190        0.341           69          132        0.523           23
    ## 191        0.316           19           35        0.543            8
    ## 192        0.311          275          586        0.469          172
    ## 193        0.353          173          380        0.455          133
    ## 194           NA          242          471        0.514          106
    ## 195        0.400            9           27        0.333            9
    ## 196        0.367          164          331        0.495          191
    ## 197        0.292           54           90        0.600           32
    ## 198        0.368          119          275        0.433          122
    ## 199        0.351          203          335        0.606           72
    ## 200        0.333          155          320        0.484          143
    ## 201        0.365          118          284        0.415           18
    ## 202        0.368           54           90        0.600           19
    ## 203        0.200          225          457        0.492           73
    ## 204        0.333           12           25        0.480            9
    ## 205        0.311           95          200        0.475          105
    ## 206        0.182           11           23        0.478            2
    ## 207        0.308           30           48        0.625           23
    ## 208        0.346          421          785        0.536          295
    ## 209        0.321          112          196        0.571           67
    ## 210        0.295          160          359        0.446           91
    ## 211        0.372          117          244        0.480          115
    ## 212        0.385           69          141        0.489           35
    ## 213        0.304          119          198        0.601           39
    ## 214        0.282           35           62        0.565           23
    ## 215        0.434           29           70        0.414           43
    ## 216        0.330           51          122        0.418           54
    ## 217        0.224          220          475        0.463          190
    ## 218        0.341          200          427        0.468          204
    ## 219        0.376           96          201        0.478          126
    ## 220        0.321          280          513        0.546           74
    ## 221        0.362          155          238        0.651           72
    ## 222           NA            8           16        0.500            3
    ## 223        0.375          132          244        0.541           43
    ## 224        0.308          191          387        0.494          151
    ## 225        0.374          150          270        0.556           44
    ## 226        0.250           60          109        0.550           21
    ## 227        0.000          208          315        0.660           56
    ## 228        0.375          434          714        0.608          336
    ## 229        0.222           54           98        0.551           21
    ## 230        0.414          376          729        0.516          186
    ## 231        0.346           20           38        0.526           20
    ## 232        0.333           65          122        0.533           29
    ## 233        0.333          172          313        0.550           42
    ## 234        0.411          351          654        0.537          325
    ## 235        0.000          164          305        0.538           98
    ## 236        0.321           19           46        0.413            5
    ## 237        0.379           58          138        0.420           27
    ## 238           NA          248          420        0.590           80
    ## 239        0.399           34           61        0.557           28
    ## 240        0.391           41           93        0.441           21
    ## 241           NA          161          259        0.622           65
    ## 242           NA           10           16        0.625            5
    ## 243        0.294          147          319        0.461           99
    ## 244        0.381          489          925        0.529          469
    ## 245        0.375           78          169        0.462           45
    ## 246        0.411          477          993        0.480          220
    ## 247        0.392           82          212        0.387           86
    ## 248        0.413          126          266        0.474           66
    ## 249        0.538          247          500        0.494          130
    ## 250        0.333          242          500        0.484           85
    ## 251        0.400            9           25        0.360            2
    ## 252           NA            5            7        0.714            4
    ## 253           NA          362          563        0.643           94
    ## 254        0.372          166          355        0.468          147
    ## 255        0.000            1            5        0.200            1
    ## 256        0.347          412          777        0.530          746
    ## 257        0.308            0            1        0.000            1
    ## 258        0.318           61          135        0.452           98
    ## 259        0.143          224          338        0.663           76
    ## 260        0.382          118          255        0.463           73
    ## 261        0.403          119          267        0.446          129
    ## 262        0.321          143          242        0.591           38
    ## 263        0.344          135          243        0.556           93
    ## 264        0.381           14           23        0.609            6
    ## 265        0.318           16           36        0.444           12
    ## 266        0.371          212          432        0.491          132
    ## 267        0.336          441          858        0.514          320
    ## 268        0.333          106          183        0.579           77
    ## 269           NA            2            7        0.286            0
    ## 270        0.411          250          483        0.518          232
    ## 271        0.000          412          575        0.717          205
    ## 272           NA            3           13        0.231            4
    ## 273        0.429          195          422        0.462          180
    ## 274        0.360          243          547        0.444          174
    ## 275        0.391          148          268        0.552           59
    ## 276        0.372          141          271        0.520          120
    ## 277        0.349           13           27        0.481           10
    ## 278        0.319          175          370        0.473           50
    ## 279        0.246           44           82        0.537           11
    ## 280        0.329           74          172        0.430           60
    ## 281        0.247          126          246        0.512           26
    ## 282        0.295          111          215        0.516           58
    ## 283        0.300          200          407        0.491           67
    ## 284        0.403          195          373        0.523          157
    ## 285        0.398          396          782        0.506          362
    ## 286        0.000           55          102        0.539           36
    ## 287        0.441           81          172        0.471           50
    ## 288        0.411          167          368        0.454           63
    ## 289        0.250            8           12        0.667            3
    ## 290        0.323           31           60        0.517            8
    ## 291        0.373          158          360        0.439           90
    ## 292        0.000          413          622        0.664          311
    ## 293        0.308          133          261        0.510           53
    ## 294        0.319           94          235        0.400           57
    ## 295        0.381           40           94        0.426           44
    ## 296        0.245          170          279        0.609           47
    ## 297        0.321          141          322        0.438           44
    ## 298        0.362           35           66        0.530           12
    ## 299        0.132          397          699        0.568          224
    ## 300        0.377          103          197        0.523           86
    ## 301        0.500            4            7        0.571            0
    ## 302        0.189           27           46        0.587           13
    ## 303        0.000           14           22        0.636            5
    ## 304        0.231           13           39        0.333            8
    ## 305        0.343          624         1358        0.459          710
    ## 306        0.190           65          160        0.406           17
    ## 307        0.000          374          654        0.572          157
    ## 308        1.000           88          178        0.494           28
    ## 309        0.361          285          580        0.491          116
    ## 310        0.276           74          204        0.363          148
    ## 311        0.000           83          134        0.619           23
    ## 312        0.269           50          129        0.388           35
    ## 313           NA           24           47        0.511           10
    ## 314        0.372           95          184        0.516           86
    ## 315        0.379          195          355        0.549          134
    ## 316        0.360           49          126        0.389           40
    ## 317        0.388          428          892        0.480          278
    ## 318        0.408          293          590        0.497          316
    ## 319        0.278          259          541        0.479           80
    ## 320        0.389           47          140        0.336           43
    ## 321        0.378           81          194        0.418           88
    ## 322        0.136           33           93        0.355           31
    ## 323        0.143           17           29        0.586           12
    ## 324        0.223          412          870        0.474          141
    ## 325        0.330          113          254        0.445           96
    ## 326        0.444          169          345        0.490          105
    ## 327        0.420          507         1001        0.506          268
    ## 328        0.370          447          910        0.491          488
    ## 329           NA           75          142        0.528           50
    ## 330        0.263          204          434        0.470           85
    ## 331        0.255           13           38        0.342           13
    ## 332        0.000          120          235        0.511           64
    ## 333        0.351          246          430        0.572           77
    ## 334        0.347           72          165        0.436           35
    ## 335        0.350          123          250        0.492           60
    ## 336        0.515           20           39        0.513            7
    ## 337        0.370           39           91        0.429           38
    ## 338        0.385            8           16        0.500            0
    ## 339        0.388          209          425        0.492          349
    ## 340        0.453           42           98        0.429           19
    ## 341        0.316          152          374        0.406          131
    ## 342        0.420          213          381        0.559          104
    ## 343        0.334          180          385        0.468          106
    ## 344        0.388          162          331        0.489           45
    ## 345        0.411           55          111        0.495           57
    ## 346        0.000          228          409        0.557          131
    ## 347        0.321           24           45        0.533            8
    ## 348        0.000           99          180        0.550           47
    ## 349        0.400            1            3        0.333            2
    ## 350        0.324          449          717        0.626          188
    ## 351           NA            2            3        0.667            0
    ## 352        0.370          208          432        0.481          143
    ## 353        0.337          323          614        0.526          141
    ## 354        0.000           89          174        0.511           29
    ## 355        0.299          730         1393        0.524          519
    ## 356        0.333            4            5        0.800            0
    ## 357           NA           36           76        0.474           15
    ## 358        0.392          103          178        0.579           16
    ## 359        0.375          106          218        0.486           94
    ## 360        0.234           46           91        0.505           25
    ## 361        0.370          206          411        0.501           57
    ## 362        0.389           68          123        0.553           20
    ## 363        0.356          305          613        0.498          119
    ## 364           NA           31           65        0.477           23
    ## 365        0.500           16           29        0.552            2
    ## 366        0.348           89          207        0.430          103
    ## 367        0.313          123          276        0.446           98
    ## 368        0.500           12           32        0.375            9
    ## 369        0.000            3            5        0.600            2
    ## 370        0.328           78          164        0.476          107
    ## 371        0.378          217          469        0.463           98
    ## 372        0.293           68          142        0.479           46
    ## 373        0.284          173          303        0.571          107
    ## 374        0.351          521         1058        0.492          242
    ## 375        0.358           89          195        0.456           44
    ## 376        0.333           13           29        0.448            5
    ## 377           NA           77          134        0.575           34
    ## 378        0.305           23           46        0.500           17
    ## 379        0.333           87          134        0.649           36
    ## 380        0.425          201          381        0.528           85
    ## 381        0.363          159          368        0.432          146
    ## 382        0.403           82          196        0.418           64
    ## 383        0.391           65          121        0.537           61
    ## 384        0.411          123          269        0.457           83
    ## 385        0.382          115          249        0.462           70
    ## 386        0.428           83          158        0.525           35
    ## 387        0.417          267          539        0.495          147
    ## 388        0.373          101          212        0.476           58
    ## 389        0.000           56          100        0.560           12
    ## 390        0.000          216          391        0.552           38
    ## 391        0.475           23           64        0.359           11
    ## 392        0.286           20           40        0.500           15
    ## 393        0.372          159          329        0.483          118
    ## 394        0.375          114          210        0.543           52
    ## 395        0.288          203          404        0.502          173
    ## 396        0.438           38           95        0.400           24
    ## 397        0.000          255          479        0.532          101
    ## 398        0.200           20           39        0.513           14
    ## 399        0.356          606         1281        0.473          412
    ## 400        0.386           26           73        0.356           13
    ## 401           NA           45           86        0.523           15
    ## 402        0.372          316          618        0.511          136
    ## 403           NA            5           13        0.385            2
    ## 404        0.367          701         1204        0.582          356
    ## 405        0.288           97          240        0.404           36
    ## 406        0.316           95          179        0.531           45
    ## 407        0.200           17           29        0.586            5
    ## 408        0.306          201          454        0.443          254
    ## 409        0.336          239          452        0.529          147
    ## 410        0.356           49          108        0.454           33
    ## 411        0.387          206          400        0.515          117
    ## 412        0.294          221          499        0.443          133
    ## 413        0.208           48           97        0.495           18
    ## 414        0.352          216          483        0.447          147
    ## 415        0.200           46           76        0.605           25
    ## 416        0.000          126          235        0.536           32
    ## 417        0.329          360          715        0.503          134
    ## 418        0.270          360          710        0.507          204
    ## 419        0.278          180          325        0.554           59
    ## 420        0.309          113          259        0.436           46
    ## 421        0.237           10           30        0.333           10
    ## 422        0.404          102          212        0.481           77
    ## 423        0.500          149          292        0.510           82
    ## 424        0.000          105          195        0.538           31
    ## 425        0.000          169          327        0.517           63
    ## 426        0.389           44           90        0.489           19
    ## 427        0.000          138          266        0.519           70
    ## 428        0.250          227          451        0.503          150
    ## 429        0.324          164          386        0.425          132
    ## 430        0.273           65          110        0.591           29
    ## 431        0.363          459         1026        0.447          367
    ## 432        0.277           29           60        0.483            4
    ## 433        0.000            1            5        0.200            1
    ## 434        0.335          345          724        0.477          388
    ## 435        0.379           80          143        0.559           43
    ## 436        0.357          137          294        0.466           40
    ## 437        0.321          212          408        0.520          113
    ## 438        0.176            1            7        0.143            3
    ## 439        0.265          377          716        0.527          119
    ## 440        0.266          163          358        0.455           55
    ## 441           NA          153          228        0.671           91
    ##     points1_atts points1_perc off_rebounds def_rebounds assists steals
    ## 1            135        0.800           95          369     337     52
    ## 2            100        0.670          117          248     140     52
    ## 3             93        0.731           65          269     121     68
    ## 4              6        0.500            2            2       3      0
    ## 5             41        0.805           17           68      33      9
    ## 6            649        0.909           43          162     449     70
    ## 7            217        0.811           48          367     155     72
    ## 8              9        0.667            6           20       4     10
    ## 9            124        0.685           45          175      64     35
    ## 10            37        0.703           60          213      71     26
    ## 11            14        0.571           13           21       7      3
    ## 12           123        0.732           72          288     148     43
    ## 13           250        0.812           78          228     364    125
    ## 14            66        0.773           40          187     131     45
    ## 15            39        0.564           43           81      42      7
    ## 16            74        0.851           37          253      45     33
    ## 17             4        0.750            1            1       1      0
    ## 18            25        0.840            1           44      86      6
    ## 19            39        0.692            3           54      14      5
    ## 20             1        0.000            4            6       1      0
    ## 21            90        0.789           39          180     109     62
    ## 22            15        0.667           17           96      62     40
    ## 23            20        0.650            3           35      14      7
    ## 24            49        0.714            3           38      58     18
    ## 25           295        0.871          148          518     116     53
    ## 26            15        0.933            7           90      35     11
    ## 27           328        0.905           52          178     418     83
    ## 28           531        0.674           97          543     646     92
    ## 29           108        0.741           28          174      78     26
    ## 30           213        0.498          287          429      77     39
    ## 31             0           NA            5            5       4      2
    ## 32           122        0.770           52          184     265     66
    ## 33            55        0.764           16           32      57     27
    ## 34           647        0.842           70          316     290     78
    ## 35           117        0.761           63          212      74     81
    ## 36            22        0.818            4           38      35     17
    ## 37            57        0.544           78           87      12     18
    ## 38           217        0.811          226          533      57     37
    ## 39           365        0.819           48          239     417     88
    ## 40            67        0.657           82          161      42     52
    ## 41           159        0.792           26          142      82     51
    ## 42            16        0.688           23          106      26     31
    ## 43            32        0.688           64          122      17     26
    ## 44            60        0.717           62          229      76     40
    ## 45            34        0.882           29          127      15      7
    ## 46            76        0.934           14           66      21     10
    ## 47           342        0.825           53          186     267     83
    ## 48            17        0.706            8           36     108     15
    ## 49             2        0.500            0            2       0      1
    ## 50             2        0.000            5           17       3      2
    ## 51            75        0.573           47          103      19     33
    ## 52            51        0.686           64          194      37     21
    ## 53           527        0.801           58          268     831    157
    ## 54           159        0.648          238          611     121     40
    ## 55           215        0.837          107          385     126     82
    ## 56           119        0.832          118          397     121    116
    ## 57            27        0.852            4           30      15      8
    ## 58            33        0.697           25           58      92     26
    ## 59            29        0.759            7           40     100     11
    ## 60            16        0.375           14           45      28      8
    ## 61           255        0.855           42          206     499     74
    ## 62           424        0.533          296          644     104     64
    ## 63            65        0.800           42          109      43     22
    ## 64             8        0.875            7           25      37      4
    ## 65           168        0.708           45          186     177     91
    ## 66            82        0.780           60          146      29     15
    ## 67            93        0.806           11          113     193     39
    ## 68            26        0.846           13           55      30      9
    ## 69            64        0.766           76          164      95     30
    ## 70           405        0.768          111          422     252     90
    ## 71             6        0.833            1           17       8      4
    ## 72            75        0.733           54          216     107     96
    ## 73           214        0.766           35          189     182     55
    ## 74           612        0.770          142          558     434    131
    ## 75           239        0.741          167          365     187     92
    ## 76           218        0.743           79          235     142     51
    ## 77            29        0.828           15           91      98     45
    ## 78           107        0.692           92          203      57     29
    ## 79            92        0.880           11          112      99     41
    ## 80           126        0.865           47          166     317     84
    ## 81            96        0.854           24          123     357     53
    ## 82           105        0.743           40          153      53     28
    ## 83            45        0.778           11          151      48     12
    ## 84             5        0.400            4           45      23     19
    ## 85            18        0.778            6           39      19      2
    ## 86            49        0.653           40           74      23     10
    ## 87            58        0.810           22          226      96     54
    ## 88            40        0.800           18           51     125     25
    ## 89            85        0.765           75          203      57     19
    ## 90            93        0.903           30          199      48     46
    ## 91             2        1.000            2           15       5      3
    ## 92           415        0.867           33          298     639    100
    ## 93            15        0.733            1           16      15      4
    ## 94            22        0.636           41          101      23      7
    ## 95             3        0.667            1           23      25      3
    ## 96            33        0.697          105          115      57     18
    ## 97           128        0.727           19          185     236     79
    ## 98           303        0.809          139          448     106     74
    ## 99           374        0.898           58          434     251    117
    ## 100           29        0.724           26           30       4      3
    ## 101           86        0.523          131          318     122    114
    ## 102           11        1.000            1            1       6      2
    ## 103           59        0.661           75          220      35     16
    ## 104            4        0.250            1           16      15      4
    ## 105           93        0.645          124          187      40     25
    ## 106           18        0.778           11          140      63     30
    ## 107          281        0.794           64          207     229     86
    ## 108           33        0.909            6           43      37     22
    ## 109           73        0.890           17           94     120     47
    ## 110          676        0.865          128          342     417    143
    ## 111           15        0.600           21           47      19      7
    ## 112           77        0.753           24          128     113     38
    ## 113          128        0.773           61          323      75     53
    ## 114           40        0.775           15          110      36     15
    ## 115           50        0.600           73          282     461     99
    ## 116          104        0.721          244          276      80     18
    ## 117          127        0.646           18          136     200     41
    ## 118          377        0.790           61          217     423     89
    ## 119          358        0.628          293          795      57     56
    ## 120          215        0.707           66          309     276     76
    ## 121            9        0.667           23           51      50     10
    ## 122           77        0.779           35          133     140     60
    ## 123           47        0.617           23           71      66     27
    ## 124           15        0.733           13          129      36     21
    ## 125           22        0.909           25           57      21     10
    ## 126           71        0.620           95          162     124     45
    ## 127          254        0.768           50          243     233     84
    ## 128           15        0.600            8           28       6      5
    ## 129           43        0.860           18          115      70     35
    ## 130           88        0.557          129          203      26     18
    ## 131          355        0.386          345          771      89    124
    ## 132           94        0.840          111          222      32     17
    ## 133           34        0.941            6           51     131     13
    ## 134           58        0.810           46           84       9      6
    ## 135           28        0.750            2           31      33     11
    ## 136            8        0.500            8           33       7      1
    ## 137          102        0.706           21          214     418     61
    ## 138          113        0.867          102          300     111     31
    ## 139          185        0.832           55          193     193     89
    ## 140          185        0.784           77          289     160     52
    ## 141            2        1.000            2            1       2      0
    ## 142            7        0.714           13           51      29     18
    ## 143          136        0.868           21           92     270     35
    ## 144           53        0.679           36          153     105     56
    ## 145          226        0.841           63          353     142     60
    ## 146           39        0.846            5           34      52      9
    ## 147           13        0.692            8           14      16      9
    ## 148           15        0.733           14           15       2      3
    ## 149          196        0.679          135          270      99     62
    ## 150          156        0.756           57          279     162     47
    ## 151          129        0.853           30          234      75     27
    ## 152            2        0.500            4            4       4      0
    ## 153          359        0.847           45          263     435     85
    ## 154          168        0.893           14          164     147     44
    ## 155          150        0.873           89          409     106     58
    ## 156          194        0.784          156          409     114     81
    ## 157            4        0.750           15           27       3      7
    ## 158          284        0.856           46          435     455     86
    ## 159          118        0.771           11           62     129     26
    ## 160           15        0.667            5           17       6      6
    ## 161          365        0.833           62          374     213     60
    ## 162           31        0.935            6           21      28      6
    ## 163           98        0.867           53          207     179     81
    ## 164          253        0.874           66          180     283     44
    ## 165           78        0.436          161          241     103     30
    ## 166           80        0.825           27          198     102     65
    ## 167          252        0.786          111          364      97     47
    ## 168           83        0.771          157          282     117     36
    ## 169           51        0.843           32          110      35     21
    ## 170           19        0.421           23           28      10      4
    ## 171           26        0.731           22           42       8     15
    ## 172           68        0.809           47           79      69     29
    ## 173           43        0.651           12           86     107     34
    ## 174           24        0.708           12           47      52     13
    ## 175          125        0.728          170          332      96     41
    ## 176          217        0.719          116          289     150     64
    ## 177          234        0.534          157          410      74     25
    ## 178           66        0.864           16           73     114     43
    ## 179          161        0.814           15          102     209     31
    ## 180            0           NA            5           20      20     12
    ## 181          211        0.692           89          298     529     88
    ## 182          277        0.805           44          165     202     66
    ## 183          168        0.863           39          175      81     37
    ## 184           74        0.878            5           72      45     34
    ## 185           10        0.900            1            8       3      1
    ## 186           50        0.800           20          126      62     30
    ## 187          160        0.669          176          603     208     77
    ## 188            0           NA            1            6       0      0
    ## 189            5        0.600           11           24       4      2
    ## 190           27        0.852            4           64      43     34
    ## 191           10        0.800           11           18       5      3
    ## 192          220        0.782          112          402     182     57
    ## 193          165        0.806           34          151     112     41
    ## 194          158        0.671           81          159      58     20
    ## 195           10        0.900            3            9      13      0
    ## 196          244        0.783           61          182      66     27
    ## 197           41        0.780           30           66      34     13
    ## 198          150        0.813           21          205     188     46
    ## 199          103        0.699           94          217      58     42
    ## 200          174        0.822           92          344     102    127
    ## 201           27        0.667           21          136     344     48
    ## 202           35        0.543           41           44      13      9
    ## 203           90        0.811           39          212     534    133
    ## 204           11        0.818            8           14       4      1
    ## 205          123        0.854           25          123      75     32
    ## 206            2        1.000            4           23       3      5
    ## 207           32        0.719            7           21      23      4
    ## 208          364        0.810          121          282     176     38
    ## 209           93        0.720           23          165     110     49
    ## 210          113        0.805           32          152     192     42
    ## 211          141        0.816           11          124     184     41
    ## 212           49        0.714           16          131      54     30
    ## 213           52        0.750           71          191      55     29
    ## 214           28        0.821            9           43       9     12
    ## 215           57        0.754           18           89      18     14
    ## 216           63        0.857            9          146     135     35
    ## 217          253        0.751           96          356     154     82
    ## 218          242        0.843           22          258     157     46
    ## 219          159        0.792           27          137     185     44
    ## 220          110        0.673          142          428     138     76
    ## 221          102        0.706           51          253     262     76
    ## 222           10        0.300            9           14       0      1
    ## 223           56        0.768           47          156     151     42
    ## 224          213        0.709           98          501     533    154
    ## 225           58        0.759           22          100      90     39
    ## 226           42        0.500           34           56      17     18
    ## 227          111        0.505          100          144      17     19
    ## 228          384        0.875           39          474     300     66
    ## 229           34        0.618           44           80      29     14
    ## 230          218        0.853           49          236     160     66
    ## 231           23        0.870           15           76      45     12
    ## 232           37        0.784           22           79      77     32
    ## 233           60        0.700           28          123     139     38
    ## 234          362        0.898           61          292     523    143
    ## 235          126        0.778          140          270     132     59
    ## 236            6        0.833            2           21      23      1
    ## 237           32        0.844           31          193     124     71
    ## 238          113        0.708          148          292     124     31
    ## 239           34        0.824           22           77      46     20
    ## 240           30        0.700            6           36      48      8
    ## 241           93        0.699          129          366      44     37
    ## 242            8        0.625            8           23       3      2
    ## 243          132        0.750           20          140     126     47
    ## 244          533        0.880           80          350     260    132
    ## 245           57        0.789           33          175      91     51
    ## 246          271        0.812          174          350     139     46
    ## 247          107        0.804           28          129     183     82
    ## 248           80        0.825           24          118     280     65
    ## 249          184        0.707          107          394     150     24
    ## 250          117        0.726            9          104     285     33
    ## 251            2        1.000            0            6      14      1
    ## 252            4        1.000            2            8       3      3
    ## 253          177        0.531          178          348      64     34
    ## 254          175        0.840           29          172     188     48
    ## 255            2        0.500            1            2       3      1
    ## 256          881        0.847           95          564     906    120
    ## 257            2        0.500            4            6       2      3
    ## 258          113        0.867           12           58      56     15
    ## 259          121        0.628           81          138      64     20
    ## 260           95        0.768           95          299     281     99
    ## 261          150        0.860          112          218      68     32
    ## 262           68        0.559           94          190      76     38
    ## 263          126        0.738           54          405     175    147
    ## 264            7        0.857            9           15       6      3
    ## 265           16        0.750            3           21      11      3
    ## 266          191        0.691           20          141     204     48
    ## 267          421        0.760          111          385     300     58
    ## 268           88        0.875           43           86      21     14
    ## 269            0           NA            1            2       1      2
    ## 270          260        0.892           41          263     563    118
    ## 271          425        0.482          297          817      96     52
    ## 272            4        1.000            1            5       0      0
    ## 273          202        0.891           11          160     110     55
    ## 274          203        0.857           17          112     213     59
    ## 275           87        0.678           47          127      39     81
    ## 276          137        0.876           88          285      66     23
    ## 277           13        0.769            1           47      10      4
    ## 278           64        0.781           33          184     191     67
    ## 279           17        0.647           26          155      23     29
    ## 280           78        0.769           17          103      30     18
    ## 281           35        0.743           46          112     170     18
    ## 282           73        0.795           30          102     112     21
    ## 283          109        0.615           92          213      56     45
    ## 284          196        0.801           23          144     203     50
    ## 285          429        0.844           49          344     252     73
    ## 286           48        0.750           52           69       7     16
    ## 287           68        0.735           23          237     224     96
    ## 288           77        0.818           33          209     144     35
    ## 289            6        0.500            4           13       2      1
    ## 290            9        0.889            4           26      34     21
    ## 291          115        0.783           16          186      96     39
    ## 292          476        0.653          314          721      97     49
    ## 293           77        0.688           20          108     154     42
    ## 294           79        0.722           48          187      70     26
    ## 295           49        0.898           18           68      40     37
    ## 296          111        0.423           98          304      79     94
    ## 297           67        0.657           45          242      82     39
    ## 298           17        0.706            6           43      13      2
    ## 299          285        0.786          195          287      67     32
    ## 300          139        0.619           38          161      46     33
    ## 301            1        0.000            4            5       3      0
    ## 302           17        0.765            8           40       9      7
    ## 303            8        0.625            9           21      12      2
    ## 304           10        0.800            0           11      14      8
    ## 305          840        0.845          137          727     840    133
    ## 306           31        0.548           19           69     130     28
    ## 307          257        0.611          282          333      86     88
    ## 308           39        0.718           38           65      13     14
    ## 309          154        0.753           39          252     176     78
    ## 310          194        0.763           23          113     198     54
    ## 311           35        0.657           31           47      15     11
    ## 312           43        0.814            6           78      55     20
    ## 313           18        0.556           20           40       2      3
    ## 314          110        0.782           69          190      64     46
    ## 315          167        0.802          167          377      84     46
    ## 316           50        0.800           42          120       8     17
    ## 317          332        0.837           60          402     338     67
    ## 318          368        0.859           31          211     433     92
    ## 319          130        0.615          166          225      98    115
    ## 320           54        0.796           21           79      46     21
    ## 321          115        0.765           36          191     133     60
    ## 322           37        0.838           11           35      61     18
    ## 323           18        0.667            1           10      12      4
    ## 324          193        0.731          182          416     122     38
    ## 325          136        0.706           77          374      99     60
    ## 326          124        0.847           19          206      93     54
    ## 327          294        0.912           60          231     285     72
    ## 328          545        0.895           46          322     439     68
    ## 329           81        0.617           96          147      27     15
    ## 330          103        0.825           36          211     205     53
    ## 331           17        0.765            6           18      11      9
    ## 332           97        0.660           65          142      63     25
    ## 333          124        0.621          125          216      89     85
    ## 334           40        0.875           27          209      71     13
    ## 335           94        0.638          131          256      31     30
    ## 336            9        0.778           10           42      28      6
    ## 337           49        0.776            8           53      67     32
    ## 338            3        0.000            4           10      11      2
    ## 339          387        0.902           39          287     136     41
    ## 340           22        0.864           25           87      42     19
    ## 341          167        0.784           30          150     217     41
    ## 342          134        0.776           48          130     164     71
    ## 343          120        0.883           41          173     170     53
    ## 344           63        0.714           28          164     385     53
    ## 345           76        0.750           43          144      29     29
    ## 346          189        0.693          180          279      55     43
    ## 347           10        0.800            5           12      11      7
    ## 348           76        0.618           50          123      70     19
    ## 349            2        1.000            3           36      22      2
    ## 350          228        0.825          212          503     358     60
    ## 351            0           NA            1            1       1      0
    ## 352          190        0.753           58          201     206     48
    ## 353          194        0.727          104          356     143     52
    ## 354           40        0.725           46          131      12     20
    ## 355          647        0.802          174          712     157     94
    ## 356            0           NA            0            1       0      1
    ## 357           21        0.714           23           50       4      4
    ## 358           27        0.593           56          221      36     39
    ## 359          121        0.777           38          174      66     25
    ## 360           49        0.510           26           75      34     18
    ## 361           74        0.770           33          119     164     50
    ## 362           26        0.769            4           30      57     11
    ## 363          168        0.708           46          218     488    100
    ## 364           39        0.590           48          115      15      5
    ## 365            3        0.667            1            3      14      3
    ## 366          128        0.805           51          256     141     71
    ## 367          129        0.760           34          139     335     56
    ## 368           20        0.450            8           28       4      1
    ## 369            3        0.667            3            4       0      2
    ## 370          129        0.829           11          116     136     43
    ## 371          112        0.875           23          330      82     30
    ## 372           61        0.754           55          166      67     52
    ## 373          141        0.759           94          213      49     61
    ## 374          281        0.861           94          303     117     66
    ## 375           51        0.863            9           75     193     14
    ## 376            7        0.714            8           14       9      2
    ## 377           48        0.708           47          103      20     22
    ## 378           22        0.773           26           69      47     17
    ## 379           61        0.590           97          211      14     32
    ## 380          100        0.850           25          153     188     79
    ## 381          179        0.816           18          241     210     77
    ## 382           73        0.877           16           83     155     40
    ## 383           82        0.744           51          188      77     33
    ## 384           93        0.892            9          116      78     21
    ## 385           93        0.753           19          111      51     29
    ## 386           43        0.814           16           87      44     20
    ## 387          171        0.860           23          130     312     67
    ## 388           74        0.784           32          151     169     84
    ## 389           14        0.857           24           62      20      3
    ## 390           62        0.613          118          285      47     36
    ## 391           12        0.917            7           28      28      6
    ## 392           19        0.789            3           20      11      5
    ## 393          138        0.855           35          155      82     44
    ## 394           74        0.703           51          111      27     16
    ## 395          217        0.797           44          135     335     74
    ## 396           34        0.706            7           44      33     12
    ## 397          151        0.669           85          255      80     53
    ## 398           19        0.737            9           24       7      8
    ## 399          542        0.760          103          226     189     82
    ## 400           18        0.722           16           83      45     22
    ## 401           22        0.682           51          107      25     25
    ## 402          167        0.814          188          459     158     88
    ## 403            2        1.000            8            6       0      1
    ## 404          428        0.832          296          711     220     57
    ## 405           59        0.610           24          142     188     78
    ## 406           61        0.738           57          187      79     40
    ## 407            8        0.625            6           14      11     13
    ## 408          285        0.891           68          237     682    128
    ## 409          190        0.774           84          136      35     22
    ## 410           43        0.767           10           57     156     47
    ## 411          140        0.836           18          141     139     41
    ## 412          214        0.621           60          257     166     50
    ## 413           24        0.750           11           41      36     24
    ## 414          188        0.782           31          191     303     87
    ## 415           39        0.641           16           46      14     13
    ## 416           49        0.653           41          118      30     14
    ## 417          168        0.798           49          197     213     88
    ## 418          282        0.723          151          485     264     49
    ## 419           80        0.738          120          249      96     82
    ## 420           63        0.730           63          232      74     48
    ## 421           16        0.625            5           15      11      9
    ## 422           90        0.856           25          112      58     37
    ## 423          109        0.752          143          199      39     30
    ## 424           66        0.470           84          139      31     26
    ## 425           78        0.808          104          160      43     16
    ## 426           22        0.864            6           21      52     20
    ## 427          112        0.625           94          198      23     27
    ## 428          208        0.721          156          354      44     37
    ## 429          154        0.857           25           93     130     27
    ## 430           41        0.707           39           40      12     14
    ## 431          441        0.832           46          203     268     72
    ## 432           11        0.364           23           80      23     10
    ## 433            2        0.500            3            3       1      0
    ## 434          458        0.847           52          268     418     92
    ## 435           65        0.662           31          194     121     42
    ## 436           45        0.889           15           89      81     31
    ## 437          181        0.624           96          252      60     67
    ## 438            4        0.750            3            8      18     11
    ## 439          154        0.773          125          214      75     76
    ## 440           71        0.775           20           75     226     48
    ## 441          124        0.734          154          385      30     33
    ##     blocks turnovers fouls
    ## 1       87       116   138
    ## 2       62        77   211
    ## 3       11        88   141
    ## 4        0         0     0
    ## 5        7        25    48
    ## 6       13       210   167
    ## 7       23        79   161
    ## 8        2         4    15
    ## 9       18        68   142
    ## 10      17        39   122
    ## 11       6         9    12
    ## 12      29        96   207
    ## 13      34       159   192
    ## 14      11        47    69
    ## 15      21        20    61
    ## 16      37        53   138
    ## 17       0         1     1
    ## 18       6        40    42
    ## 19       2        14    27
    ## 20       6         2     3
    ## 21      27        78   150
    ## 22      11        26    77
    ## 23      10        10    37
    ## 24       7        31    38
    ## 25      22       122   125
    ## 26       8        29    60
    ## 27      25       180   157
    ## 28      44       303   134
    ## 29      10        52   153
    ## 30      84        64   176
    ## 31       1         2     4
    ## 32      13       109   140
    ## 33      11        25    31
    ## 34      13       180   134
    ## 35      27        54   143
    ## 36       2        15    36
    ## 37      20        29   113
    ## 38      63       106   216
    ## 39      19       173   170
    ## 40      90        46   137
    ## 41      14        70   127
    ## 42       5        14    53
    ## 43      45        33   109
    ## 44      23        38   120
    ## 45      33        39    76
    ## 46       4        38    47
    ## 47      21       157   169
    ## 48       0        22    32
    ## 49       0         1     0
    ## 50       0         3    17
    ## 51      24        34    90
    ## 52      55        58   168
    ## 53      49       323   151
    ## 54      65       118   213
    ## 55      42       129   254
    ## 56      41        43   193
    ## 57       2         5    17
    ## 58       6        38    60
    ## 59       5        48    54
    ## 60       5        16    21
    ## 61      16       258   149
    ## 62      92       170   203
    ## 63       8        34    73
    ## 64       0        15    14
    ## 65      52       125   165
    ## 66      21        28    69
    ## 67       1        95   112
    ## 68       5        14    35
    ## 69      41        55    97
    ## 70      62       158   186
    ## 71       5         4     5
    ## 72      31        58    97
    ## 73      15       106   103
    ## 74     151       234   246
    ## 75      38       140   168
    ## 76      22        92   111
    ## 77      20        36    95
    ## 78      78        53   151
    ## 79       7        65    79
    ## 80      12       113   140
    ## 81       0       133   153
    ## 82      27        66    92
    ## 83      13        37   109
    ## 84      10        14    32
    ## 85       4         9    16
    ## 86      26        17    84
    ## 87      14        55   125
    ## 88       9        66    93
    ## 89      16        33   125
    ## 90      25        40   151
    ## 91       0         5     6
    ## 92      32       216   165
    ## 93       0         5     5
    ## 94      20        29    66
    ## 95       2        11    12
    ## 96      24        29    78
    ## 97      27       135   149
    ## 98     173       105   262
    ## 99      27       218   206
    ## 100      6         8    37
    ## 101     30        96   135
    ## 102      0         0     4
    ## 103     11        37    94
    ## 104      0        13    14
    ## 105     16        33   110
    ## 106      7        49    86
    ## 107     41       138   112
    ## 108      1        20    35
    ## 109      8        44    93
    ## 110     32       159   112
    ## 111      0        16    12
    ## 112     23        66   102
    ## 113     56        79   128
    ## 114     16        40    78
    ## 115     11       168   144
    ## 116    117        90   151
    ## 117     20       103    95
    ## 118     13       212   199
    ## 119    161       154   226
    ## 120     86       171   197
    ## 121      4        23    31
    ## 122     39        65   132
    ## 123      6        33    52
    ## 124     11        25   118
    ## 125     10        18    52
    ## 126     18        56   140
    ## 127     44        90   176
    ## 128      1         8    22
    ## 129      4        30    70
    ## 130     47        31   137
    ## 131     89       152   237
    ## 132     39        50   166
    ## 133      0        37    29
    ## 134     12        10    25
    ## 135      2        28    39
    ## 136      1        14     6
    ## 137     33       112   127
    ## 138     26        66   145
    ## 139     12        86   118
    ## 140     25        87   168
    ## 141      0         0     2
    ## 142      3        10    22
    ## 143      5       114   129
    ## 144     24        71   121
    ## 145     39        95   133
    ## 146      1        26    18
    ## 147      0         5    12
    ## 148      6         7    11
    ## 149     58        65   189
    ## 150     34        76   139
    ## 151     23        40    98
    ## 152      0         3     6
    ## 153     22       168   119
    ## 154      9        70    90
    ## 155     53        60   134
    ## 156     77        56   187
    ## 157      4         8    25
    ## 158     29       194   109
    ## 159      3        46    43
    ## 160      1         3    18
    ## 161     34       153   198
    ## 162      1        16    28
    ## 163     23        69   141
    ## 164     17       147    84
    ## 165     37        58   127
    ## 166     31        66   109
    ## 167    130       118   244
    ## 168    104        76   174
    ## 169      5        25    85
    ## 170      4        12    23
    ## 171      8        12    30
    ## 172     11        51    79
    ## 173      8        56    74
    ## 174      2        16    38
    ## 175     36       100   150
    ## 176     40        89   172
    ## 177     91        95   202
    ## 178      2        47    84
    ## 179      1        90   101
    ## 180      1         9    31
    ## 181     40       178   177
    ## 182      4       141   180
    ## 183     13        75   103
    ## 184      4        36    41
    ## 185      0         2     5
    ## 186     14        58    74
    ## 187     74       117   180
    ## 188      0         3     4
    ## 189      5         3    17
    ## 190     13        35    61
    ## 191      2         3    14
    ## 192     30       183   162
    ## 193     15        62   129
    ## 194     49        91   122
    ## 195      0         9     4
    ## 196     76       117   112
    ## 197      7        26    45
    ## 198     32       128   144
    ## 199     55        55   136
    ## 200     69       131   203
    ## 201      4       128    95
    ## 202      9        13    49
    ## 203     10       159   139
    ## 204      1         6     8
    ## 205     10        73   154
    ## 206      0         6    18
    ## 207      4        14     7
    ## 208    124       184   192
    ## 209      8        59    91
    ## 210     36       142   175
    ## 211     14        86    79
    ## 212      8        55   121
    ## 213     43        43    91
    ## 214     10        19    25
    ## 215     15        19    58
    ## 216      9        80    99
    ## 217     44       116   177
    ## 218      6       136   118
    ## 219     23        66   119
    ## 220     28       127   152
    ## 221     39        58    97
    ## 222      4         6    15
    ## 223     48        78   105
    ## 224    106       184   217
    ## 225      8        55    77
    ## 226     29        19    47
    ## 227     67        40   109
    ## 228     99       138   117
    ## 229     17        17    64
    ## 230     40       128   139
    ## 231      9        24    47
    ## 232     15        36    62
    ## 233     20        61   120
    ## 234     17       239   183
    ## 235     33        88   166
    ## 236      0        11    20
    ## 237     58        76   120
    ## 238     40        82   125
    ## 239     28        32    75
    ## 240      6        38    29
    ## 241     61        61   180
    ## 242      6         4    11
    ## 243     25        76   146
    ## 244     55       154   122
    ## 245     26        39    63
    ## 246     89        98   158
    ## 247     16        96   119
    ## 248      3       101   109
    ## 249     70        81   110
    ## 250      2        89    92
    ## 251      0         5     5
    ## 252      1         4     6
    ## 253     80        87   179
    ## 254     40       121   150
    ## 255      1         0     6
    ## 256     37       464   215
    ## 257      1         5     4
    ## 258      9        40    25
    ## 259     42        44   126
    ## 260     25       100   222
    ## 261     14        55   142
    ## 262     21        41    83
    ## 263     20        74   133
    ## 264      1         6    18
    ## 265      0         7    35
    ## 266     10       115   187
    ## 267     23       142   157
    ## 268     11        29    45
    ## 269      1         1     0
    ## 270      8       147   146
    ## 271    135       116   212
    ## 272      1         2     5
    ## 273     13        98   125
    ## 274     14       134   115
    ## 275     35        47   122
    ## 276     41        69   229
    ## 277      5        16    40
    ## 278     22        83   125
    ## 279     30        18    83
    ## 280      5        35    50
    ## 281      9        87    83
    ## 282     12        80   146
    ## 283     40        60   103
    ## 284     11        85   114
    ## 285     20       140   117
    ## 286     32        14    52
    ## 287      8       107   163
    ## 288     18        69    93
    ## 289      2         2     1
    ## 290      5        15    48
    ## 291     11        65   132
    ## 292    214       148   246
    ## 293      3        90   100
    ## 294     20        64    97
    ## 295      8        33   114
    ## 296     79        51   204
    ## 297     32        83   200
    ## 298      1         6    22
    ## 299     38       123   154
    ## 300     75        41   144
    ## 301      3         0     0
    ## 302      5        11    29
    ## 303      2         4    17
    ## 304      0         7    18
    ## 305     31       438   190
    ## 306      6        43    79
    ## 307     78       146   195
    ## 308     15        28    40
    ## 309     21       119   155
    ## 310     20        85   194
    ## 311     20        10    42
    ## 312      5        24    52
    ## 313     17         8    40
    ## 314     19        59   165
    ## 315     34        94   248
    ## 316      9        28    91
    ## 317     99       166   171
    ## 318     19       156   126
    ## 319     29       100   178
    ## 320      4        45    90
    ## 321     36        50   163
    ## 322      7        40    40
    ## 323      1         9    12
    ## 324     10        99   136
    ## 325     44        94   102
    ## 326     20        62   171
    ## 327     42       172   202
    ## 328     20       197   152
    ## 329     22        37   137
    ## 330     24       100   121
    ## 331      3        11    22
    ## 332     38        62    73
    ## 333     70        85   214
    ## 334     28        35   172
    ## 335     27        64   154
    ## 336      2        17    23
    ## 337      2        41    38
    ## 338      3        11     6
    ## 339     15        81    93
    ## 340     21        36    76
    ## 341     13       123    95
    ## 342      8        76    92
    ## 343     24       113   124
    ## 344      8       129   197
    ## 345     12        31    62
    ## 346     40        58   124
    ## 347      0         8    10
    ## 348     29        46    77
    ## 349      0        13     9
    ## 350     55       171   214
    ## 351      2         1     3
    ## 352     28        97   110
    ## 353     30       114   172
    ## 354     22        31    77
    ## 355    167       181   168
    ## 356      1         0     5
    ## 357      7         7    17
    ## 358     28        28   100
    ## 359     19        62    75
    ## 360     11        31    55
    ## 361     32        62   131
    ## 362      2        25    30
    ## 363     43       194   133
    ## 364     10        14    51
    ## 365      0         5     7
    ## 366     32        82   182
    ## 367      6       101   133
    ## 368     13        10    21
    ## 369      0         0     3
    ## 370      7        57   101
    ## 371     38        51   113
    ## 372     25        45   125
    ## 373     39        34   135
    ## 374     15       102   128
    ## 375      1        63    30
    ## 376      4         3     8
    ## 377     25        22    55
    ## 378      8        26    43
    ## 379     61        40   152
    ## 380      7        92   126
    ## 381     16       102   161
    ## 382      7        56    79
    ## 383     20        56   109
    ## 384      7        42   104
    ## 385      6        62   108
    ## 386      2        53    34
    ## 387      9       114   119
    ## 388     28        78   141
    ## 389     17        24    44
    ## 390     48        61   172
    ## 391      1        18    20
    ## 392      1         8    23
    ## 393     26        74    79
    ## 394     13        37    64
    ## 395      6       129   119
    ## 396      5        22    19
    ## 397     45        69   147
    ## 398      7         8    32
    ## 399     30       187   183
    ## 400     23        28    42
    ## 401     23        17    85
    ## 402     95       107   254
    ## 403      0         4     9
    ## 404    103       212   241
    ## 405     36        89   178
    ## 406     20        59   154
    ## 407      2        10    24
    ## 408     10       195   202
    ## 409      6        56    86
    ## 410      5        38    50
    ## 411     10        85   104
    ## 412     36       116   158
    ## 413      8        19    29
    ## 414     16       176   130
    ## 415      7        11    36
    ## 416     33        30    66
    ## 417      8       164   150
    ## 418     37       173   248
    ## 419     40        56   149
    ## 420     20        43    61
    ## 421      2         7    18
    ## 422     14        36   137
    ## 423     44        58   173
    ## 424      9        46    76
    ## 425     31        72   133
    ## 426      2        21    29
    ## 427     32        37   125
    ## 428     98       102   242
    ## 429      5        89    87
    ## 430     13        13    63
    ## 431     21       241   242
    ## 432     22        32    74
    ## 433      0         2     2
    ## 434     31       223   164
    ## 435     16        72   154
    ## 436      8        48    82
    ## 437     70       108   263
    ## 438      1         3    14
    ## 439     39        57   175
    ## 440      5        77    73
    ## 441     24        67   126

Examples:

Ex 1: Select the player column only from dat!

``` r
sqldf("SELECT 
      player 
      FROM dat")
```

    ##                       player
    ## 1                 Al Horford
    ## 2               Amir Johnson
    ## 3              Avery Bradley
    ## 4          Demetrius Jackson
    ## 5               Gerald Green
    ## 6              Isaiah Thomas
    ## 7                Jae Crowder
    ## 8                James Young
    ## 9               Jaylen Brown
    ## 10             Jonas Jerebko
    ## 11             Jordan Mickey
    ## 12              Kelly Olynyk
    ## 13              Marcus Smart
    ## 14              Terry Rozier
    ## 15              Tyler Zeller
    ## 16             Channing Frye
    ## 17             Dahntay Jones
    ## 18            Deron Williams
    ## 19          Derrick Williams
    ## 20               Edy Tavares
    ## 21             Iman Shumpert
    ## 22                J.R. Smith
    ## 23               James Jones
    ## 24                Kay Felder
    ## 25                Kevin Love
    ## 26               Kyle Korver
    ## 27              Kyrie Irving
    ## 28              LeBron James
    ## 29         Richard Jefferson
    ## 30          Tristan Thompson
    ## 31             Bruno Caboclo
    ## 32               Cory Joseph
    ## 33              Delon Wright
    ## 34             DeMar DeRozan
    ## 35           DeMarre Carroll
    ## 36             Fred VanVleet
    ## 37              Jakob Poeltl
    ## 38         Jonas Valanciunas
    ## 39                Kyle Lowry
    ## 40            Lucas Nogueira
    ## 41             Norman Powell
    ## 42               P.J. Tucker
    ## 43             Pascal Siakam
    ## 44         Patrick Patterson
    ## 45               Serge Ibaka
    ## 46          Bojan Bogdanovic
    ## 47              Bradley Beal
    ## 48          Brandon Jennings
    ## 49          Chris McCullough
    ## 50             Daniel Ochefu
    ## 51               Ian Mahinmi
    ## 52               Jason Smith
    ## 53                 John Wall
    ## 54             Marcin Gortat
    ## 55           Markieff Morris
    ## 56               Otto Porter
    ## 57         Sheldon McClellan
    ## 58          Tomas Satoransky
    ## 59                Trey Burke
    ## 60           DeAndre' Bembry
    ## 61           Dennis Schroder
    ## 62             Dwight Howard
    ## 63            Ersan Ilyasova
    ## 64             Jose Calderon
    ## 65             Kent Bazemore
    ## 66            Kris Humphries
    ## 67           Malcolm Delaney
    ## 68             Mike Dunleavy
    ## 69              Mike Muscala
    ## 70              Paul Millsap
    ## 71                Ryan Kelly
    ## 72           Thabo Sefolosha
    ## 73              Tim Hardaway
    ## 74     Giannis Antetokounmpo
    ## 75               Greg Monroe
    ## 76             Jabari Parker
    ## 77               Jason Terry
    ## 78               John Henson
    ## 79           Khris Middleton
    ## 80           Malcolm Brogdon
    ## 81       Matthew Dellavedova
    ## 82           Michael Beasley
    ## 83           Mirza Teletovic
    ## 84             Rashad Vaughn
    ## 85             Spencer Hawes
    ## 86                Thon Maker
    ## 87                Tony Snell
    ## 88              Aaron Brooks
    ## 89              Al Jefferson
    ## 90                C.J. Miles
    ## 91             Georges Niang
    ## 92               Jeff Teague
    ## 93                 Joe Young
    ## 94            Kevin Seraphin
    ## 95          Lance Stephenson
    ## 96               Lavoy Allen
    ## 97               Monta Ellis
    ## 98              Myles Turner
    ## 99               Paul George
    ## 100         Rakeem Christmas
    ## 101           Thaddeus Young
    ## 102           Anthony Morrow
    ## 103             Bobby Portis
    ## 104            Cameron Payne
    ## 105        Cristiano Felicio
    ## 106         Denzel Valentine
    ## 107              Dwyane Wade
    ## 108            Isaiah Canaan
    ## 109             Jerian Grant
    ## 110             Jimmy Butler
    ## 111        Joffrey Lauvergne
    ## 112  Michael Carter-Williams
    ## 113           Nikola Mirotic
    ## 114              Paul Zipser
    ## 115              Rajon Rondo
    ## 116              Robin Lopez
    ## 117             Dion Waiters
    ## 118             Goran Dragic
    ## 119         Hassan Whiteside
    ## 120            James Johnson
    ## 121           Josh McRoberts
    ## 122          Josh Richardson
    ## 123          Justise Winslow
    ## 124             Luke Babbitt
    ## 125              Okaro White
    ## 126          Rodney McGruder
    ## 127            Tyler Johnson
    ## 128            Udonis Haslem
    ## 129          Wayne Ellington
    ## 130              Willie Reed
    ## 131           Andre Drummond
    ## 132              Aron Baynes
    ## 133               Beno Udrih
    ## 134         Boban Marjanovic
    ## 135          Darrun Hilliard
    ## 136           Henry Ellenson
    ## 137                Ish Smith
    ## 138                Jon Leuer
    ## 139 Kentavious Caldwell-Pope
    ## 140            Marcus Morris
    ## 141          Michael Gbinije
    ## 142           Reggie Bullock
    ## 143           Reggie Jackson
    ## 144          Stanley Johnson
    ## 145            Tobias Harris
    ## 146            Brian Roberts
    ## 147            Briante Weber
    ## 148           Christian Wood
    ## 149              Cody Zeller
    ## 150           Frank Kaminsky
    ## 151              Jeremy Lamb
    ## 152          Johnny O'Bryant
    ## 153             Kemba Walker
    ## 154          Marco Belinelli
    ## 155          Marvin Williams
    ## 156   Michael Kidd-Gilchrist
    ## 157            Miles Plumlee
    ## 158            Nicolas Batum
    ## 159           Ramon Sessions
    ## 160           Treveon Graham
    ## 161          Carmelo Anthony
    ## 162           Chasson Randle
    ## 163             Courtney Lee
    ## 164             Derrick Rose
    ## 165              Joakim Noah
    ## 166           Justin Holiday
    ## 167       Kristaps Porzingis
    ## 168             Kyle O'Quinn
    ## 169             Lance Thomas
    ## 170         Marshall Plumlee
    ## 171            Maurice Ndour
    ## 172     Mindaugas Kuzminskas
    ## 173                Ron Baker
    ## 174            Sasha Vujacic
    ## 175        Willy Hernangomez
    ## 176             Aaron Gordon
    ## 177          Bismack Biyombo
    ## 178              C.J. Watson
    ## 179            D.J. Augustin
    ## 180             Damjan Rudez
    ## 181            Elfrid Payton
    ## 182            Evan Fournier
    ## 183               Jeff Green
    ## 184              Jodie Meeks
    ## 185      Marcus Georges-Hunt
    ## 186            Mario Hezonja
    ## 187           Nikola Vucevic
    ## 188          Patricio Garino
    ## 189        Stephen Zimmerman
    ## 190            Terrence Ross
    ## 191           Alex Poythress
    ## 192              Dario Saric
    ## 193         Gerald Henderson
    ## 194            Jahlil Okafor
    ## 195           Jerryd Bayless
    ## 196              Joel Embiid
    ## 197          Justin Anderson
    ## 198             Nik Stauskas
    ## 199           Richaun Holmes
    ## 200         Robert Covington
    ## 201         Sergio Rodriguez
    ## 202               Shawn Long
    ## 203           T.J. McConnell
    ## 204           Tiago Splitter
    ## 205  Timothe Luwawu-Cabarrot
    ## 206         Andrew Nicholson
    ## 207           Archie Goodwin
    ## 208              Brook Lopez
    ## 209             Caris LeVert
    ## 210         Isaiah Whitehead
    ## 211               Jeremy Lin
    ## 212               Joe Harris
    ## 213          Justin Hamilton
    ## 214           K.J. McDaniels
    ## 215               Quincy Acy
    ## 216               Randy Foye
    ## 217  Rondae Hollis-Jefferson
    ## 218          Sean Kilpatrick
    ## 219        Spencer Dinwiddie
    ## 220            Trevor Booker
    ## 221           Andre Iguodala
    ## 222             Damian Jones
    ## 223               David West
    ## 224           Draymond Green
    ## 225                Ian Clark
    ## 226     James Michael McAdoo
    ## 227             JaVale McGee
    ## 228             Kevin Durant
    ## 229             Kevon Looney
    ## 230            Klay Thompson
    ## 231              Matt Barnes
    ## 232            Patrick McCaw
    ## 233         Shaun Livingston
    ## 234            Stephen Curry
    ## 235            Zaza Pachulia
    ## 236              Bryn Forbes
    ## 237              Danny Green
    ## 238                David Lee
    ## 239            Davis Bertans
    ## 240          Dejounte Murray
    ## 241           Dewayne Dedmon
    ## 242             Joel Anthony
    ## 243         Jonathon Simmons
    ## 244            Kawhi Leonard
    ## 245            Kyle Anderson
    ## 246        LaMarcus Aldridge
    ## 247            Manu Ginobili
    ## 248              Patty Mills
    ## 249                Pau Gasol
    ## 250              Tony Parker
    ## 251              Bobby Brown
    ## 252           Chinanu Onuaku
    ## 253             Clint Capela
    ## 254              Eric Gordon
    ## 255            Isaiah Taylor
    ## 256             James Harden
    ## 257             Kyle Wiltjer
    ## 258             Lou Williams
    ## 259         Montrezl Harrell
    ## 260         Patrick Beverley
    ## 261            Ryan Anderson
    ## 262               Sam Dekker
    ## 263             Trevor Ariza
    ## 264            Troy Williams
    ## 265            Alan Anderson
    ## 266            Austin Rivers
    ## 267            Blake Griffin
    ## 268             Brandon Bass
    ## 269            Brice Johnson
    ## 270               Chris Paul
    ## 271           DeAndre Jordan
    ## 272            Diamond Stone
    ## 273              J.J. Redick
    ## 274           Jamal Crawford
    ## 275         Luc Mbah a Moute
    ## 276        Marreese Speights
    ## 277              Paul Pierce
    ## 278           Raymond Felton
    ## 279           Wesley Johnson
    ## 280               Alec Burks
    ## 281               Boris Diaw
    ## 282               Dante Exum
    ## 283           Derrick Favors
    ## 284              George Hill
    ## 285           Gordon Hayward
    ## 286              Jeff Withey
    ## 287               Joe Ingles
    ## 288              Joe Johnson
    ## 289            Joel Bolomboy
    ## 290                Raul Neto
    ## 291              Rodney Hood
    ## 292              Rudy Gobert
    ## 293             Shelvin Mack
    ## 294               Trey Lyles
    ## 295             Alex Abrines
    ## 296           Andre Roberson
    ## 297         Domantas Sabonis
    ## 298           Doug McDermott
    ## 299              Enes Kanter
    ## 300             Jerami Grant
    ## 301             Josh Huestis
    ## 302             Kyle Singler
    ## 303            Nick Collison
    ## 304              Norris Cole
    ## 305        Russell Westbrook
    ## 306           Semaj Christon
    ## 307             Steven Adams
    ## 308               Taj Gibson
    ## 309           Victor Oladipo
    ## 310          Andrew Harrison
    ## 311           Brandan Wright
    ## 312         Chandler Parsons
    ## 313            Deyonta Davis
    ## 314              James Ennis
    ## 315           JaMychal Green
    ## 316            Jarell Martin
    ## 317               Marc Gasol
    ## 318              Mike Conley
    ## 319               Tony Allen
    ## 320             Troy Daniels
    ## 321             Vince Carter
    ## 322             Wade Baldwin
    ## 323             Wayne Selden
    ## 324            Zach Randolph
    ## 325          Al-Farouq Aminu
    ## 326             Allen Crabbe
    ## 327            C.J. McCollum
    ## 328           Damian Lillard
    ## 329                 Ed Davis
    ## 330              Evan Turner
    ## 331              Jake Layman
    ## 332             Jusuf Nurkic
    ## 333         Maurice Harkless
    ## 334           Meyers Leonard
    ## 335              Noah Vonleh
    ## 336          Pat Connaughton
    ## 337           Shabazz Napier
    ## 338           Tim Quarterman
    ## 339         Danilo Gallinari
    ## 340           Darrell Arthur
    ## 341          Emmanuel Mudiay
    ## 342              Gary Harris
    ## 343             Jamal Murray
    ## 344            Jameer Nelson
    ## 345         Juan Hernangomez
    ## 346           Kenneth Faried
    ## 347            Malik Beasley
    ## 348            Mason Plumlee
    ## 349              Mike Miller
    ## 350             Nikola Jokic
    ## 351              Roy Hibbert
    ## 352              Will Barton
    ## 353          Wilson Chandler
    ## 354            Alexis Ajinca
    ## 355            Anthony Davis
    ## 356             Axel Toupane
    ## 357            Cheick Diallo
    ## 358         Dante Cunningham
    ## 359         DeMarcus Cousins
    ## 360       Donatas Motiejunas
    ## 361            E'Twaun Moore
    ## 362          Jordan Crawford
    ## 363             Jrue Holiday
    ## 364                Omer Asik
    ## 365               Quinn Cook
    ## 366             Solomon Hill
    ## 367              Tim Frazier
    ## 368             A.J. Hammons
    ## 369          DeAndre Liggins
    ## 370             Devin Harris
    ## 371            Dirk Nowitzki
    ## 372      Dorian Finney-Smith
    ## 373            Dwight Powell
    ## 374          Harrison Barnes
    ## 375               J.J. Barea
    ## 376            Jarrod Uthoff
    ## 377             Nerlens Noel
    ## 378         Nicolas Brussino
    ## 379              Salah Mejri
    ## 380               Seth Curry
    ## 381          Wesley Matthews
    ## 382             Yogi Ferrell
    ## 383         Anthony Tolliver
    ## 384            Arron Afflalo
    ## 385             Ben McLemore
    ## 386              Buddy Hield
    ## 387          Darren Collison
    ## 388           Garrett Temple
    ## 389     Georgios Papagiannis
    ## 390             Kosta Koufos
    ## 391        Langston Galloway
    ## 392       Malachi Richardson
    ## 393                 Rudy Gay
    ## 394          Skal Labissiere
    ## 395                Ty Lawson
    ## 396             Tyreke Evans
    ## 397      Willie Cauley-Stein
    ## 398            Adreian Payne
    ## 399           Andrew Wiggins
    ## 400             Brandon Rush
    ## 401             Cole Aldrich
    ## 402             Gorgui Dieng
    ## 403              Jordan Hill
    ## 404       Karl-Anthony Towns
    ## 405                Kris Dunn
    ## 406          Nemanja Bjelica
    ## 407              Omri Casspi
    ## 408              Ricky Rubio
    ## 409         Shabazz Muhammad
    ## 410               Tyus Jones
    ## 411              Zach LaVine
    ## 412           Brandon Ingram
    ## 413             Corey Brewer
    ## 414         D'Angelo Russell
    ## 415              David Nwaba
    ## 416              Ivica Zubac
    ## 417          Jordan Clarkson
    ## 418            Julius Randle
    ## 419          Larry Nance Jr.
    ## 420                Luol Deng
    ## 421        Metta World Peace
    ## 422               Nick Young
    ## 423              Tarik Black
    ## 424          Thomas Robinson
    ## 425           Timofey Mozgov
    ## 426              Tyler Ennis
    ## 427            Alan Williams
    ## 428                 Alex Len
    ## 429           Brandon Knight
    ## 430            Derrick Jones
    ## 431             Devin Booker
    ## 432            Dragan Bender
    ## 433           Elijah Millsap
    ## 434             Eric Bledsoe
    ## 435             Jared Dudley
    ## 436          Leandro Barbosa
    ## 437          Marquese Chriss
    ## 438             Ronnie Price
    ## 439              T.J. Warren
    ## 440               Tyler Ulis
    ## 441           Tyson Chandler

Ex 2: Select the columns, player, and games\_played from dat but change the name of games\_played to gp!

``` r
sqldf("SELECT
      player
      , games_played as gp
      FROM dat")
```

    ##                       player gp
    ## 1                 Al Horford 68
    ## 2               Amir Johnson 80
    ## 3              Avery Bradley 55
    ## 4          Demetrius Jackson  5
    ## 5               Gerald Green 47
    ## 6              Isaiah Thomas 76
    ## 7                Jae Crowder 72
    ## 8                James Young 29
    ## 9               Jaylen Brown 78
    ## 10             Jonas Jerebko 78
    ## 11             Jordan Mickey 25
    ## 12              Kelly Olynyk 75
    ## 13              Marcus Smart 79
    ## 14              Terry Rozier 74
    ## 15              Tyler Zeller 51
    ## 16             Channing Frye 74
    ## 17             Dahntay Jones  1
    ## 18            Deron Williams 24
    ## 19          Derrick Williams 25
    ## 20               Edy Tavares  1
    ## 21             Iman Shumpert 76
    ## 22                J.R. Smith 41
    ## 23               James Jones 48
    ## 24                Kay Felder 42
    ## 25                Kevin Love 60
    ## 26               Kyle Korver 35
    ## 27              Kyrie Irving 72
    ## 28              LeBron James 74
    ## 29         Richard Jefferson 79
    ## 30          Tristan Thompson 78
    ## 31             Bruno Caboclo  9
    ## 32               Cory Joseph 80
    ## 33              Delon Wright 27
    ## 34             DeMar DeRozan 74
    ## 35           DeMarre Carroll 72
    ## 36             Fred VanVleet 37
    ## 37              Jakob Poeltl 54
    ## 38         Jonas Valanciunas 80
    ## 39                Kyle Lowry 60
    ## 40            Lucas Nogueira 57
    ## 41             Norman Powell 76
    ## 42               P.J. Tucker 24
    ## 43             Pascal Siakam 55
    ## 44         Patrick Patterson 65
    ## 45               Serge Ibaka 23
    ## 46          Bojan Bogdanovic 26
    ## 47              Bradley Beal 77
    ## 48          Brandon Jennings 23
    ## 49          Chris McCullough  2
    ## 50             Daniel Ochefu 19
    ## 51               Ian Mahinmi 31
    ## 52               Jason Smith 74
    ## 53                 John Wall 78
    ## 54             Marcin Gortat 82
    ## 55           Markieff Morris 76
    ## 56               Otto Porter 80
    ## 57         Sheldon McClellan 30
    ## 58          Tomas Satoransky 57
    ## 59                Trey Burke 57
    ## 60           DeAndre' Bembry 38
    ## 61           Dennis Schroder 79
    ## 62             Dwight Howard 74
    ## 63            Ersan Ilyasova 26
    ## 64             Jose Calderon 17
    ## 65             Kent Bazemore 73
    ## 66            Kris Humphries 56
    ## 67           Malcolm Delaney 73
    ## 68             Mike Dunleavy 30
    ## 69              Mike Muscala 70
    ## 70              Paul Millsap 69
    ## 71                Ryan Kelly 16
    ## 72           Thabo Sefolosha 62
    ## 73              Tim Hardaway 79
    ## 74     Giannis Antetokounmpo 80
    ## 75               Greg Monroe 81
    ## 76             Jabari Parker 51
    ## 77               Jason Terry 74
    ## 78               John Henson 58
    ## 79           Khris Middleton 29
    ## 80           Malcolm Brogdon 75
    ## 81       Matthew Dellavedova 76
    ## 82           Michael Beasley 56
    ## 83           Mirza Teletovic 70
    ## 84             Rashad Vaughn 41
    ## 85             Spencer Hawes 19
    ## 86                Thon Maker 57
    ## 87                Tony Snell 80
    ## 88              Aaron Brooks 65
    ## 89              Al Jefferson 66
    ## 90                C.J. Miles 76
    ## 91             Georges Niang 23
    ## 92               Jeff Teague 82
    ## 93                 Joe Young 33
    ## 94            Kevin Seraphin 49
    ## 95          Lance Stephenson  6
    ## 96               Lavoy Allen 61
    ## 97               Monta Ellis 74
    ## 98              Myles Turner 81
    ## 99               Paul George 75
    ## 100         Rakeem Christmas 29
    ## 101           Thaddeus Young 74
    ## 102           Anthony Morrow  9
    ## 103             Bobby Portis 64
    ## 104            Cameron Payne 11
    ## 105        Cristiano Felicio 66
    ## 106         Denzel Valentine 57
    ## 107              Dwyane Wade 60
    ## 108            Isaiah Canaan 39
    ## 109             Jerian Grant 63
    ## 110             Jimmy Butler 76
    ## 111        Joffrey Lauvergne 20
    ## 112  Michael Carter-Williams 45
    ## 113           Nikola Mirotic 70
    ## 114              Paul Zipser 44
    ## 115              Rajon Rondo 69
    ## 116              Robin Lopez 81
    ## 117             Dion Waiters 46
    ## 118             Goran Dragic 73
    ## 119         Hassan Whiteside 77
    ## 120            James Johnson 76
    ## 121           Josh McRoberts 22
    ## 122          Josh Richardson 53
    ## 123          Justise Winslow 18
    ## 124             Luke Babbitt 68
    ## 125              Okaro White 35
    ## 126          Rodney McGruder 78
    ## 127            Tyler Johnson 73
    ## 128            Udonis Haslem 17
    ## 129          Wayne Ellington 62
    ## 130              Willie Reed 71
    ## 131           Andre Drummond 81
    ## 132              Aron Baynes 75
    ## 133               Beno Udrih 39
    ## 134         Boban Marjanovic 35
    ## 135          Darrun Hilliard 39
    ## 136           Henry Ellenson 19
    ## 137                Ish Smith 81
    ## 138                Jon Leuer 75
    ## 139 Kentavious Caldwell-Pope 76
    ## 140            Marcus Morris 79
    ## 141          Michael Gbinije  9
    ## 142           Reggie Bullock 31
    ## 143           Reggie Jackson 52
    ## 144          Stanley Johnson 77
    ## 145            Tobias Harris 82
    ## 146            Brian Roberts 41
    ## 147            Briante Weber 13
    ## 148           Christian Wood 13
    ## 149              Cody Zeller 62
    ## 150           Frank Kaminsky 75
    ## 151              Jeremy Lamb 62
    ## 152          Johnny O'Bryant  4
    ## 153             Kemba Walker 79
    ## 154          Marco Belinelli 74
    ## 155          Marvin Williams 76
    ## 156   Michael Kidd-Gilchrist 81
    ## 157            Miles Plumlee 13
    ## 158            Nicolas Batum 77
    ## 159           Ramon Sessions 50
    ## 160           Treveon Graham 27
    ## 161          Carmelo Anthony 74
    ## 162           Chasson Randle 18
    ## 163             Courtney Lee 77
    ## 164             Derrick Rose 64
    ## 165              Joakim Noah 46
    ## 166           Justin Holiday 82
    ## 167       Kristaps Porzingis 66
    ## 168             Kyle O'Quinn 79
    ## 169             Lance Thomas 46
    ## 170         Marshall Plumlee 21
    ## 171            Maurice Ndour 32
    ## 172     Mindaugas Kuzminskas 68
    ## 173                Ron Baker 52
    ## 174            Sasha Vujacic 42
    ## 175        Willy Hernangomez 72
    ## 176             Aaron Gordon 80
    ## 177          Bismack Biyombo 81
    ## 178              C.J. Watson 62
    ## 179            D.J. Augustin 78
    ## 180             Damjan Rudez 45
    ## 181            Elfrid Payton 82
    ## 182            Evan Fournier 68
    ## 183               Jeff Green 69
    ## 184              Jodie Meeks 36
    ## 185      Marcus Georges-Hunt  5
    ## 186            Mario Hezonja 65
    ## 187           Nikola Vucevic 75
    ## 188          Patricio Garino  5
    ## 189        Stephen Zimmerman 19
    ## 190            Terrence Ross 24
    ## 191           Alex Poythress  6
    ## 192              Dario Saric 81
    ## 193         Gerald Henderson 72
    ## 194            Jahlil Okafor 50
    ## 195           Jerryd Bayless  3
    ## 196              Joel Embiid 31
    ## 197          Justin Anderson 24
    ## 198             Nik Stauskas 80
    ## 199           Richaun Holmes 57
    ## 200         Robert Covington 67
    ## 201         Sergio Rodriguez 68
    ## 202               Shawn Long 18
    ## 203           T.J. McConnell 81
    ## 204           Tiago Splitter  8
    ## 205  Timothe Luwawu-Cabarrot 69
    ## 206         Andrew Nicholson 10
    ## 207           Archie Goodwin 12
    ## 208              Brook Lopez 75
    ## 209             Caris LeVert 57
    ## 210         Isaiah Whitehead 73
    ## 211               Jeremy Lin 36
    ## 212               Joe Harris 52
    ## 213          Justin Hamilton 64
    ## 214           K.J. McDaniels 20
    ## 215               Quincy Acy 32
    ## 216               Randy Foye 69
    ## 217  Rondae Hollis-Jefferson 78
    ## 218          Sean Kilpatrick 70
    ## 219        Spencer Dinwiddie 59
    ## 220            Trevor Booker 71
    ## 221           Andre Iguodala 76
    ## 222             Damian Jones 10
    ## 223               David West 68
    ## 224           Draymond Green 76
    ## 225                Ian Clark 77
    ## 226     James Michael McAdoo 52
    ## 227             JaVale McGee 77
    ## 228             Kevin Durant 62
    ## 229             Kevon Looney 53
    ## 230            Klay Thompson 78
    ## 231              Matt Barnes 20
    ## 232            Patrick McCaw 71
    ## 233         Shaun Livingston 76
    ## 234            Stephen Curry 79
    ## 235            Zaza Pachulia 70
    ## 236              Bryn Forbes 36
    ## 237              Danny Green 68
    ## 238                David Lee 79
    ## 239            Davis Bertans 67
    ## 240          Dejounte Murray 38
    ## 241           Dewayne Dedmon 76
    ## 242             Joel Anthony 19
    ## 243         Jonathon Simmons 78
    ## 244            Kawhi Leonard 74
    ## 245            Kyle Anderson 72
    ## 246        LaMarcus Aldridge 72
    ## 247            Manu Ginobili 69
    ## 248              Patty Mills 80
    ## 249                Pau Gasol 64
    ## 250              Tony Parker 63
    ## 251              Bobby Brown 25
    ## 252           Chinanu Onuaku  5
    ## 253             Clint Capela 65
    ## 254              Eric Gordon 75
    ## 255            Isaiah Taylor  4
    ## 256             James Harden 81
    ## 257             Kyle Wiltjer 14
    ## 258             Lou Williams 23
    ## 259         Montrezl Harrell 58
    ## 260         Patrick Beverley 67
    ## 261            Ryan Anderson 72
    ## 262               Sam Dekker 77
    ## 263             Trevor Ariza 80
    ## 264            Troy Williams  6
    ## 265            Alan Anderson 30
    ## 266            Austin Rivers 74
    ## 267            Blake Griffin 61
    ## 268             Brandon Bass 52
    ## 269            Brice Johnson  3
    ## 270               Chris Paul 61
    ## 271           DeAndre Jordan 81
    ## 272            Diamond Stone  7
    ## 273              J.J. Redick 78
    ## 274           Jamal Crawford 82
    ## 275         Luc Mbah a Moute 80
    ## 276        Marreese Speights 82
    ## 277              Paul Pierce 25
    ## 278           Raymond Felton 80
    ## 279           Wesley Johnson 68
    ## 280               Alec Burks 42
    ## 281               Boris Diaw 73
    ## 282               Dante Exum 66
    ## 283           Derrick Favors 50
    ## 284              George Hill 49
    ## 285           Gordon Hayward 73
    ## 286              Jeff Withey 51
    ## 287               Joe Ingles 82
    ## 288              Joe Johnson 78
    ## 289            Joel Bolomboy 12
    ## 290                Raul Neto 40
    ## 291              Rodney Hood 59
    ## 292              Rudy Gobert 81
    ## 293             Shelvin Mack 55
    ## 294               Trey Lyles 71
    ## 295             Alex Abrines 68
    ## 296           Andre Roberson 79
    ## 297         Domantas Sabonis 81
    ## 298           Doug McDermott 22
    ## 299              Enes Kanter 72
    ## 300             Jerami Grant 78
    ## 301             Josh Huestis  2
    ## 302             Kyle Singler 32
    ## 303            Nick Collison 20
    ## 304              Norris Cole 13
    ## 305        Russell Westbrook 81
    ## 306           Semaj Christon 64
    ## 307             Steven Adams 80
    ## 308               Taj Gibson 23
    ## 309           Victor Oladipo 67
    ## 310          Andrew Harrison 72
    ## 311           Brandan Wright 28
    ## 312         Chandler Parsons 34
    ## 313            Deyonta Davis 36
    ## 314              James Ennis 64
    ## 315           JaMychal Green 77
    ## 316            Jarell Martin 42
    ## 317               Marc Gasol 74
    ## 318              Mike Conley 69
    ## 319               Tony Allen 71
    ## 320             Troy Daniels 67
    ## 321             Vince Carter 73
    ## 322             Wade Baldwin 33
    ## 323             Wayne Selden 11
    ## 324            Zach Randolph 73
    ## 325          Al-Farouq Aminu 61
    ## 326             Allen Crabbe 79
    ## 327            C.J. McCollum 80
    ## 328           Damian Lillard 75
    ## 329                 Ed Davis 46
    ## 330              Evan Turner 65
    ## 331              Jake Layman 35
    ## 332             Jusuf Nurkic 20
    ## 333         Maurice Harkless 77
    ## 334           Meyers Leonard 74
    ## 335              Noah Vonleh 74
    ## 336          Pat Connaughton 39
    ## 337           Shabazz Napier 53
    ## 338           Tim Quarterman 16
    ## 339         Danilo Gallinari 63
    ## 340           Darrell Arthur 41
    ## 341          Emmanuel Mudiay 55
    ## 342              Gary Harris 57
    ## 343             Jamal Murray 82
    ## 344            Jameer Nelson 75
    ## 345         Juan Hernangomez 62
    ## 346           Kenneth Faried 61
    ## 347            Malik Beasley 22
    ## 348            Mason Plumlee 27
    ## 349              Mike Miller 20
    ## 350             Nikola Jokic 73
    ## 351              Roy Hibbert  6
    ## 352              Will Barton 60
    ## 353          Wilson Chandler 71
    ## 354            Alexis Ajinca 39
    ## 355            Anthony Davis 75
    ## 356             Axel Toupane  2
    ## 357            Cheick Diallo 17
    ## 358         Dante Cunningham 66
    ## 359         DeMarcus Cousins 17
    ## 360       Donatas Motiejunas 34
    ## 361            E'Twaun Moore 73
    ## 362          Jordan Crawford 19
    ## 363             Jrue Holiday 67
    ## 364                Omer Asik 31
    ## 365               Quinn Cook  9
    ## 366             Solomon Hill 80
    ## 367              Tim Frazier 65
    ## 368             A.J. Hammons 22
    ## 369          DeAndre Liggins  1
    ## 370             Devin Harris 65
    ## 371            Dirk Nowitzki 54
    ## 372      Dorian Finney-Smith 81
    ## 373            Dwight Powell 77
    ## 374          Harrison Barnes 79
    ## 375               J.J. Barea 35
    ## 376            Jarrod Uthoff  9
    ## 377             Nerlens Noel 22
    ## 378         Nicolas Brussino 54
    ## 379              Salah Mejri 73
    ## 380               Seth Curry 70
    ## 381          Wesley Matthews 73
    ## 382             Yogi Ferrell 36
    ## 383         Anthony Tolliver 65
    ## 384            Arron Afflalo 61
    ## 385             Ben McLemore 61
    ## 386              Buddy Hield 25
    ## 387          Darren Collison 68
    ## 388           Garrett Temple 65
    ## 389     Georgios Papagiannis 22
    ## 390             Kosta Koufos 71
    ## 391        Langston Galloway 19
    ## 392       Malachi Richardson 22
    ## 393                 Rudy Gay 30
    ## 394          Skal Labissiere 33
    ## 395                Ty Lawson 69
    ## 396             Tyreke Evans 14
    ## 397      Willie Cauley-Stein 75
    ## 398            Adreian Payne 18
    ## 399           Andrew Wiggins 82
    ## 400             Brandon Rush 47
    ## 401             Cole Aldrich 62
    ## 402             Gorgui Dieng 82
    ## 403              Jordan Hill  7
    ## 404       Karl-Anthony Towns 82
    ## 405                Kris Dunn 78
    ## 406          Nemanja Bjelica 65
    ## 407              Omri Casspi 13
    ## 408              Ricky Rubio 75
    ## 409         Shabazz Muhammad 78
    ## 410               Tyus Jones 60
    ## 411              Zach LaVine 47
    ## 412           Brandon Ingram 79
    ## 413             Corey Brewer 24
    ## 414         D'Angelo Russell 63
    ## 415              David Nwaba 20
    ## 416              Ivica Zubac 38
    ## 417          Jordan Clarkson 82
    ## 418            Julius Randle 74
    ## 419          Larry Nance Jr. 63
    ## 420                Luol Deng 56
    ## 421        Metta World Peace 25
    ## 422               Nick Young 60
    ## 423              Tarik Black 67
    ## 424          Thomas Robinson 48
    ## 425           Timofey Mozgov 54
    ## 426              Tyler Ennis 22
    ## 427            Alan Williams 47
    ## 428                 Alex Len 77
    ## 429           Brandon Knight 54
    ## 430            Derrick Jones 32
    ## 431             Devin Booker 78
    ## 432            Dragan Bender 43
    ## 433           Elijah Millsap  2
    ## 434             Eric Bledsoe 66
    ## 435             Jared Dudley 64
    ## 436          Leandro Barbosa 67
    ## 437          Marquese Chriss 82
    ## 438             Ronnie Price 14
    ## 439              T.J. Warren 66
    ## 440               Tyler Ulis 61
    ## 441           Tyson Chandler 47

Lets add a column using familiar dplyr to create a points column for further study.

``` r
library(dplyr)
```

    ## Warning: package 'dplyr' was built under R version 3.4.2

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
dat <- dat %>%
      mutate(points = 3*dat$points3_made + 2*dat$points2_made + dat$points1_made)
```

Ex 3: Construct a new data frame with only the player and the points columns, because points is the only stat that matters really matters.

``` r
dat_points_only <- sqldf("SELECT
                         player
                         , points
                         FROM dat")
dat_points_only
```

    ##                       player points
    ## 1                 Al Horford    952
    ## 2               Amir Johnson    520
    ## 3              Avery Bradley    894
    ## 4          Demetrius Jackson     10
    ## 5               Gerald Green    262
    ## 6              Isaiah Thomas   2199
    ## 7                Jae Crowder    999
    ## 8                James Young     68
    ## 9               Jaylen Brown    515
    ## 10             Jonas Jerebko    299
    ## 11             Jordan Mickey     38
    ## 12              Kelly Olynyk    678
    ## 13              Marcus Smart    835
    ## 14              Terry Rozier    410
    ## 15              Tyler Zeller    178
    ## 16             Channing Frye    676
    ## 17             Dahntay Jones      9
    ## 18            Deron Williams    179
    ## 19          Derrick Williams    156
    ## 20               Edy Tavares      6
    ## 21             Iman Shumpert    567
    ## 22                J.R. Smith    351
    ## 23               James Jones    132
    ## 24                Kay Felder    166
    ## 25                Kevin Love   1142
    ## 26               Kyle Korver    373
    ## 27              Kyrie Irving   1816
    ## 28              LeBron James   1954
    ## 29         Richard Jefferson    448
    ## 30          Tristan Thompson    630
    ## 31             Bruno Caboclo     14
    ## 32               Cory Joseph    740
    ## 33              Delon Wright    150
    ## 34             DeMar DeRozan   2020
    ## 35           DeMarre Carroll    638
    ## 36             Fred VanVleet    107
    ## 37              Jakob Poeltl    165
    ## 38         Jonas Valanciunas    959
    ## 39                Kyle Lowry   1344
    ## 40            Lucas Nogueira    253
    ## 41             Norman Powell    636
    ## 42               P.J. Tucker    139
    ## 43             Pascal Siakam    229
    ## 44         Patrick Patterson    445
    ## 45               Serge Ibaka    327
    ## 46          Bojan Bogdanovic    330
    ## 47              Bradley Beal   1779
    ## 48          Brandon Jennings     81
    ## 49          Chris McCullough      1
    ## 50             Daniel Ochefu     24
    ## 51               Ian Mahinmi    173
    ## 52               Jason Smith    420
    ## 53                 John Wall   1805
    ## 54             Marcin Gortat    883
    ## 55           Markieff Morris   1063
    ## 56               Otto Porter   1075
    ## 57         Sheldon McClellan     90
    ## 58          Tomas Satoransky    154
    ## 59                Trey Burke    285
    ## 60           DeAndre' Bembry    101
    ## 61           Dennis Schroder   1414
    ## 62             Dwight Howard   1002
    ## 63            Ersan Ilyasova    270
    ## 64             Jose Calderon     61
    ## 65             Kent Bazemore    801
    ## 66            Kris Humphries    257
    ## 67           Malcolm Delaney    391
    ## 68             Mike Dunleavy    169
    ## 69              Mike Muscala    435
    ## 70              Paul Millsap   1246
    ## 71                Ryan Kelly     25
    ## 72           Thabo Sefolosha    444
    ## 73              Tim Hardaway   1143
    ## 74     Giannis Antetokounmpo   1832
    ## 75               Greg Monroe    951
    ## 76             Jabari Parker   1025
    ## 77               Jason Terry    307
    ## 78               John Henson    392
    ## 79           Khris Middleton    426
    ## 80           Malcolm Brogdon    767
    ## 81       Matthew Dellavedova    577
    ## 82           Michael Beasley    528
    ## 83           Mirza Teletovic    451
    ## 84             Rashad Vaughn    142
    ## 85             Spencer Hawes     83
    ## 86                Thon Maker    226
    ## 87                Tony Snell    683
    ## 88              Aaron Brooks    322
    ## 89              Al Jefferson    535
    ## 90                C.J. Miles    815
    ## 91             Georges Niang     21
    ## 92               Jeff Teague   1254
    ## 93                 Joe Young     68
    ## 94            Kevin Seraphin    232
    ## 95          Lance Stephenson     43
    ## 96               Lavoy Allen    177
    ## 97               Monta Ellis    630
    ## 98              Myles Turner   1173
    ## 99               Paul George   1775
    ## 100         Rakeem Christmas     59
    ## 101           Thaddeus Young    814
    ## 102           Anthony Morrow     41
    ## 103             Bobby Portis    437
    ## 104            Cameron Payne     54
    ## 105        Cristiano Felicio    316
    ## 106         Denzel Valentine    291
    ## 107              Dwyane Wade   1096
    ## 108            Isaiah Canaan    181
    ## 109             Jerian Grant    370
    ## 110             Jimmy Butler   1816
    ## 111        Joffrey Lauvergne     89
    ## 112  Michael Carter-Williams    297
    ## 113           Nikola Mirotic    744
    ## 114              Paul Zipser    240
    ## 115              Rajon Rondo    538
    ## 116              Robin Lopez    839
    ## 117             Dion Waiters    729
    ## 118             Goran Dragic   1483
    ## 119         Hassan Whiteside   1309
    ## 120            James Johnson    975
    ## 121           Josh McRoberts    107
    ## 122          Josh Richardson    539
    ## 123          Justise Winslow    196
    ## 124             Luke Babbitt    324
    ## 125              Okaro White     98
    ## 126          Rodney McGruder    497
    ## 127            Tyler Johnson   1002
    ## 128            Udonis Haslem     31
    ## 129          Wayne Ellington    648
    ## 130              Willie Reed    374
    ## 131           Andre Drummond   1105
    ## 132              Aron Baynes    365
    ## 133               Beno Udrih    227
    ## 134         Boban Marjanovic    191
    ## 135          Darrun Hilliard    127
    ## 136           Henry Ellenson     60
    ## 137                Ish Smith    758
    ## 138                Jon Leuer    767
    ## 139 Kentavious Caldwell-Pope   1047
    ## 140            Marcus Morris   1105
    ## 141          Michael Gbinije      4
    ## 142           Reggie Bullock    141
    ## 143           Reggie Jackson    752
    ## 144          Stanley Johnson    339
    ## 145            Tobias Harris   1321
    ## 146            Brian Roberts    142
    ## 147            Briante Weber     50
    ## 148           Christian Wood     35
    ## 149              Cody Zeller    639
    ## 150           Frank Kaminsky    874
    ## 151              Jeremy Lamb    603
    ## 152          Johnny O'Bryant     18
    ## 153             Kemba Walker   1830
    ## 154          Marco Belinelli    780
    ## 155          Marvin Williams    849
    ## 156   Michael Kidd-Gilchrist    743
    ## 157            Miles Plumlee     31
    ## 158            Nicolas Batum   1164
    ## 159           Ramon Sessions    312
    ## 160           Treveon Graham     57
    ## 161          Carmelo Anthony   1659
    ## 162           Chasson Randle     95
    ## 163             Courtney Lee    835
    ## 164             Derrick Rose   1154
    ## 165              Joakim Noah    232
    ## 166           Justin Holiday    629
    ## 167       Kristaps Porzingis   1196
    ## 168             Kyle O'Quinn    496
    ## 169             Lance Thomas    275
    ## 170         Marshall Plumlee     40
    ## 171            Maurice Ndour     98
    ## 172     Mindaugas Kuzminskas    425
    ## 173                Ron Baker    215
    ## 174            Sasha Vujacic    124
    ## 175        Willy Hernangomez    587
    ## 176             Aaron Gordon   1019
    ## 177          Bismack Biyombo    483
    ## 178              C.J. Watson    281
    ## 179            D.J. Augustin    616
    ## 180             Damjan Rudez     82
    ## 181            Elfrid Payton   1046
    ## 182            Evan Fournier   1167
    ## 183               Jeff Green    638
    ## 184              Jodie Meeks    327
    ## 185      Marcus Georges-Hunt     14
    ## 186            Mario Hezonja    317
    ## 187           Nikola Vucevic   1096
    ## 188          Patricio Garino      0
    ## 189        Stephen Zimmerman     23
    ## 190            Terrence Ross    299
    ## 191           Alex Poythress     64
    ## 192              Dario Saric   1040
    ## 193         Gerald Henderson    662
    ## 194            Jahlil Okafor    590
    ## 195           Jerryd Bayless     33
    ## 196              Joel Embiid    627
    ## 197          Justin Anderson    203
    ## 198             Nik Stauskas    756
    ## 199           Richaun Holmes    559
    ## 200         Robert Covington    864
    ## 201         Sergio Rodriguez    530
    ## 202               Shawn Long    148
    ## 203           T.J. McConnell    556
    ## 204           Tiago Splitter     39
    ## 205  Timothe Luwawu-Cabarrot    445
    ## 206         Andrew Nicholson     30
    ## 207           Archie Goodwin     95
    ## 208              Brook Lopez   1539
    ## 209             Caris LeVert    468
    ## 210         Isaiah Whitehead    543
    ## 211               Jeremy Lin    523
    ## 212               Joe Harris    428
    ## 213          Justin Hamilton    442
    ## 214           K.J. McDaniels    126
    ## 215               Quincy Acy    209
    ## 216               Randy Foye    357
    ## 217  Rondae Hollis-Jefferson    675
    ## 218          Sean Kilpatrick    919
    ## 219        Spencer Dinwiddie    432
    ## 220            Trevor Booker    709
    ## 221           Andre Iguodala    574
    ## 222             Damian Jones     19
    ## 223               David West    316
    ## 224           Draymond Green    776
    ## 225                Ian Clark    527
    ## 226     James Michael McAdoo    147
    ## 227             JaVale McGee    472
    ## 228             Kevin Durant   1555
    ## 229             Kevon Looney    135
    ## 230            Klay Thompson   1742
    ## 231              Matt Barnes    114
    ## 232            Patrick McCaw    282
    ## 233         Shaun Livingston    389
    ## 234            Stephen Curry   1999
    ## 235            Zaza Pachulia    426
    ## 236              Bryn Forbes     94
    ## 237              Danny Green    497
    ## 238                David Lee    576
    ## 239            Davis Bertans    303
    ## 240          Dejounte Murray    130
    ## 241           Dewayne Dedmon    387
    ## 242             Joel Anthony     25
    ## 243         Jonathon Simmons    483
    ## 244            Kawhi Leonard   1888
    ## 245            Kyle Anderson    246
    ## 246        LaMarcus Aldridge   1243
    ## 247            Manu Ginobili    517
    ## 248              Patty Mills    759
    ## 249                Pau Gasol    792
    ## 250              Tony Parker    638
    ## 251              Bobby Brown     62
    ## 252           Chinanu Onuaku     14
    ## 253             Clint Capela    818
    ## 254              Eric Gordon   1217
    ## 255            Isaiah Taylor      3
    ## 256             James Harden   2356
    ## 257             Kyle Wiltjer     13
    ## 258             Lou Williams    343
    ## 259         Montrezl Harrell    527
    ## 260         Patrick Beverley    639
    ## 261            Ryan Anderson    979
    ## 262               Sam Dekker    504
    ## 263             Trevor Ariza    936
    ## 264            Troy Williams     58
    ## 265            Alan Anderson     86
    ## 266            Austin Rivers    889
    ## 267            Blake Griffin   1316
    ## 268             Brandon Bass    292
    ## 269            Brice Johnson      4
    ## 270               Chris Paul   1104
    ## 271           DeAndre Jordan   1029
    ## 272            Diamond Stone     10
    ## 273              J.J. Redick   1173
    ## 274           Jamal Crawford   1008
    ## 275         Luc Mbah a Moute    484
    ## 276        Marreese Speights    711
    ## 277              Paul Pierce     81
    ## 278           Raymond Felton    538
    ## 279           Wesley Johnson    186
    ## 280               Alec Burks    283
    ## 281               Boris Diaw    338
    ## 282               Dante Exum    412
    ## 283           Derrick Favors    476
    ## 284              George Hill    829
    ## 285           Gordon Hayward   1601
    ## 286              Jeff Withey    146
    ## 287               Joe Ingles    581
    ## 288              Joe Johnson    715
    ## 289            Joel Bolomboy     22
    ## 290                Raul Neto    100
    ## 291              Rodney Hood    748
    ## 292              Rudy Gobert   1137
    ## 293             Shelvin Mack    430
    ## 294               Trey Lyles    440
    ## 295             Alex Abrines    406
    ## 296           Andre Roberson    522
    ## 297         Domantas Sabonis    479
    ## 298           Doug McDermott    145
    ## 299              Enes Kanter   1033
    ## 300             Jerami Grant    421
    ## 301             Josh Huestis     14
    ## 302             Kyle Singler     88
    ## 303            Nick Collison     33
    ## 304              Norris Cole     43
    ## 305        Russell Westbrook   2558
    ## 306           Semaj Christon    183
    ## 307             Steven Adams    905
    ## 308               Taj Gibson    207
    ## 309           Victor Oladipo   1067
    ## 310          Andrew Harrison    425
    ## 311           Brandan Wright    189
    ## 312         Chandler Parsons    210
    ## 313            Deyonta Davis     58
    ## 314              James Ennis    429
    ## 315           JaMychal Green    689
    ## 316            Jarell Martin    165
    ## 317               Marc Gasol   1446
    ## 318              Mike Conley   1415
    ## 319               Tony Allen    643
    ## 320             Troy Daniels    551
    ## 321             Vince Carter    586
    ## 322             Wade Baldwin    106
    ## 323             Wayne Selden     55
    ## 324            Zach Randolph   1028
    ## 325          Al-Farouq Aminu    532
    ## 326             Allen Crabbe    845
    ## 327            C.J. McCollum   1837
    ## 328           Damian Lillard   2024
    ## 329                 Ed Davis    200
    ## 330              Evan Turner    586
    ## 331              Jake Layman     78
    ## 332             Jusuf Nurkic    304
    ## 333         Maurice Harkless    773
    ## 334           Meyers Leonard    401
    ## 335              Noah Vonleh    327
    ## 336          Pat Connaughton     98
    ## 337           Shabazz Napier    218
    ## 338           Tim Quarterman     31
    ## 339         Danilo Gallinari   1145
    ## 340           Darrell Arthur    262
    ## 341          Emmanuel Mudiay    603
    ## 342              Gary Harris    851
    ## 343             Jamal Murray    811
    ## 344            Jameer Nelson    687
    ## 345         Juan Hernangomez    305
    ## 346           Kenneth Faried    587
    ## 347            Malik Beasley     83
    ## 348            Mason Plumlee    245
    ## 349              Mike Miller     28
    ## 350             Nikola Jokic   1221
    ## 351              Roy Hibbert      4
    ## 352              Will Barton    820
    ## 353          Wilson Chandler   1117
    ## 354            Alexis Ajinca    207
    ## 355            Anthony Davis   2099
    ## 356             Axel Toupane     11
    ## 357            Cheick Diallo     87
    ## 358         Dante Cunningham    435
    ## 359         DeMarcus Cousins    414
    ## 360       Donatas Motiejunas    150
    ## 361            E'Twaun Moore    700
    ## 362          Jordan Crawford    267
    ## 363             Jrue Holiday   1029
    ## 364                Omer Asik     85
    ## 365               Quinn Cook     52
    ## 366             Solomon Hill    563
    ## 367              Tim Frazier    464
    ## 368             A.J. Hammons     48
    ## 369          DeAndre Liggins      8
    ## 370             Devin Harris    437
    ## 371            Dirk Nowitzki    769
    ## 372      Dorian Finney-Smith    350
    ## 373            Dwight Powell    516
    ## 374          Harrison Barnes   1518
    ## 375               J.J. Barea    381
    ## 376            Jarrod Uthoff     40
    ## 377             Nerlens Noel    188
    ## 378         Nicolas Brussino    150
    ## 379              Salah Mejri    213
    ## 380               Seth Curry    898
    ## 381          Wesley Matthews    986
    ## 382             Yogi Ferrell    408
    ## 383         Anthony Tolliver    461
    ## 384            Arron Afflalo    515
    ## 385             Ben McLemore    495
    ## 386              Buddy Hield    378
    ## 387          Darren Collison    900
    ## 388           Garrett Temple    506
    ## 389     Georgios Papagiannis    124
    ## 390             Kosta Koufos    470
    ## 391        Langston Galloway    114
    ## 392       Malachi Richardson     79
    ## 393                 Rudy Gay    562
    ## 394          Skal Labissiere    289
    ## 395                Ty Lawson    681
    ## 396             Tyreke Evans    163
    ## 397      Willie Cauley-Stein    611
    ## 398            Adreian Payne     63
    ## 399           Andrew Wiggins   1933
    ## 400             Brandon Rush    197
    ## 401             Cole Aldrich    105
    ## 402             Gorgui Dieng    816
    ## 403              Jordan Hill     12
    ## 404       Karl-Anthony Towns   2061
    ## 405                Kris Dunn    293
    ## 406          Nemanja Bjelica    403
    ## 407              Omri Casspi     45
    ## 408              Ricky Rubio    836
    ## 409         Shabazz Muhammad    772
    ## 410               Tyus Jones    209
    ## 411              Zach LaVine    889
    ## 412           Brandon Ingram    740
    ## 413             Corey Brewer    129
    ## 414         D'Angelo Russell    984
    ## 415              David Nwaba    120
    ## 416              Ivica Zubac    284
    ## 417          Jordan Clarkson   1205
    ## 418            Julius Randle    975
    ## 419          Larry Nance Jr.    449
    ## 420                Luol Deng    425
    ## 421        Metta World Peace     57
    ## 422               Nick Young    791
    ## 423              Tarik Black    383
    ## 424          Thomas Robinson    241
    ## 425           Timofey Mozgov    401
    ## 426              Tyler Ennis    170
    ## 427            Alan Williams    346
    ## 428                 Alex Len    613
    ## 429           Brandon Knight    595
    ## 430            Derrick Jones    168
    ## 431             Devin Booker   1726
    ## 432            Dragan Bender    146
    ## 433           Elijah Millsap      3
    ## 434             Eric Bledsoe   1390
    ## 435             Jared Dudley    434
    ## 436          Leandro Barbosa    419
    ## 437          Marquese Chriss    753
    ## 438             Ronnie Price     14
    ## 439              T.J. Warren    951
    ## 440               Tyler Ulis    444
    ## 441           Tyson Chandler    397

As referenced by R-bloggers, "R users reshape data frames while database users construct queries and return result sets. In either case, we are dealing with the same basic idea – essentially a rectangular grid containing a set of values obtained from a data source."

Let's now make a new data table that takes only some of the data provided for simplicity, let's call this dat\_stats:

``` r
dat_stats <- sqldf("SELECT
                   player
                   , points
                   , assists
                   , minutes
                   , games_played
                   FROM dat")
dat_stats
```

    ##                       player points assists minutes games_played
    ## 1                 Al Horford    952     337    2193           68
    ## 2               Amir Johnson    520     140    1608           80
    ## 3              Avery Bradley    894     121    1835           55
    ## 4          Demetrius Jackson     10       3      17            5
    ## 5               Gerald Green    262      33     538           47
    ## 6              Isaiah Thomas   2199     449    2569           76
    ## 7                Jae Crowder    999     155    2335           72
    ## 8                James Young     68       4     220           29
    ## 9               Jaylen Brown    515      64    1341           78
    ## 10             Jonas Jerebko    299      71    1232           78
    ## 11             Jordan Mickey     38       7     141           25
    ## 12              Kelly Olynyk    678     148    1538           75
    ## 13              Marcus Smart    835     364    2399           79
    ## 14              Terry Rozier    410     131    1263           74
    ## 15              Tyler Zeller    178      42     525           51
    ## 16             Channing Frye    676      45    1398           74
    ## 17             Dahntay Jones      9       1      12            1
    ## 18            Deron Williams    179      86     486           24
    ## 19          Derrick Williams    156      14     427           25
    ## 20               Edy Tavares      6       1      24            1
    ## 21             Iman Shumpert    567     109    1937           76
    ## 22                J.R. Smith    351      62    1187           41
    ## 23               James Jones    132      14     381           48
    ## 24                Kay Felder    166      58     386           42
    ## 25                Kevin Love   1142     116    1885           60
    ## 26               Kyle Korver    373      35     859           35
    ## 27              Kyrie Irving   1816     418    2525           72
    ## 28              LeBron James   1954     646    2794           74
    ## 29         Richard Jefferson    448      78    1614           79
    ## 30          Tristan Thompson    630      77    2336           78
    ## 31             Bruno Caboclo     14       4      40            9
    ## 32               Cory Joseph    740     265    2003           80
    ## 33              Delon Wright    150      57     446           27
    ## 34             DeMar DeRozan   2020     290    2620           74
    ## 35           DeMarre Carroll    638      74    1882           72
    ## 36             Fred VanVleet    107      35     294           37
    ## 37              Jakob Poeltl    165      12     626           54
    ## 38         Jonas Valanciunas    959      57    2066           80
    ## 39                Kyle Lowry   1344     417    2244           60
    ## 40            Lucas Nogueira    253      42    1088           57
    ## 41             Norman Powell    636      82    1368           76
    ## 42               P.J. Tucker    139      26     609           24
    ## 43             Pascal Siakam    229      17     859           55
    ## 44         Patrick Patterson    445      76    1599           65
    ## 45               Serge Ibaka    327      15     712           23
    ## 46          Bojan Bogdanovic    330      21     601           26
    ## 47              Bradley Beal   1779     267    2684           77
    ## 48          Brandon Jennings     81     108     374           23
    ## 49          Chris McCullough      1       0       8            2
    ## 50             Daniel Ochefu     24       3      75           19
    ## 51               Ian Mahinmi    173      19     555           31
    ## 52               Jason Smith    420      37    1068           74
    ## 53                 John Wall   1805     831    2836           78
    ## 54             Marcin Gortat    883     121    2556           82
    ## 55           Markieff Morris   1063     126    2374           76
    ## 56               Otto Porter   1075     121    2605           80
    ## 57         Sheldon McClellan     90      15     287           30
    ## 58          Tomas Satoransky    154      92     719           57
    ## 59                Trey Burke    285     100     703           57
    ## 60           DeAndre' Bembry    101      28     371           38
    ## 61           Dennis Schroder   1414     499    2485           79
    ## 62             Dwight Howard   1002     104    2199           74
    ## 63            Ersan Ilyasova    270      43     633           26
    ## 64             Jose Calderon     61      37     247           17
    ## 65             Kent Bazemore    801     177    1963           73
    ## 66            Kris Humphries    257      29     689           56
    ## 67           Malcolm Delaney    391     193    1248           73
    ## 68             Mike Dunleavy    169      30     475           30
    ## 69              Mike Muscala    435      95    1237           70
    ## 70              Paul Millsap   1246     252    2343           69
    ## 71                Ryan Kelly     25       8     110           16
    ## 72           Thabo Sefolosha    444     107    1596           62
    ## 73              Tim Hardaway   1143     182    2154           79
    ## 74     Giannis Antetokounmpo   1832     434    2845           80
    ## 75               Greg Monroe    951     187    1823           81
    ## 76             Jabari Parker   1025     142    1728           51
    ## 77               Jason Terry    307      98    1365           74
    ## 78               John Henson    392      57    1123           58
    ## 79           Khris Middleton    426      99     889           29
    ## 80           Malcolm Brogdon    767     317    1982           75
    ## 81       Matthew Dellavedova    577     357    1986           76
    ## 82           Michael Beasley    528      53     935           56
    ## 83           Mirza Teletovic    451      48    1133           70
    ## 84             Rashad Vaughn    142      23     458           41
    ## 85             Spencer Hawes     83      19     171           19
    ## 86                Thon Maker    226      23     562           57
    ## 87                Tony Snell    683      96    2336           80
    ## 88              Aaron Brooks    322     125     894           65
    ## 89              Al Jefferson    535      57     931           66
    ## 90                C.J. Miles    815      48    1776           76
    ## 91             Georges Niang     21       5      93           23
    ## 92               Jeff Teague   1254     639    2657           82
    ## 93                 Joe Young     68      15     135           33
    ## 94            Kevin Seraphin    232      23     559           49
    ## 95          Lance Stephenson     43      25     132            6
    ## 96               Lavoy Allen    177      57     871           61
    ## 97               Monta Ellis    630     236    1998           74
    ## 98              Myles Turner   1173     106    2541           81
    ## 99               Paul George   1775     251    2689           75
    ## 100         Rakeem Christmas     59       4     219           29
    ## 101           Thaddeus Young    814     122    2237           74
    ## 102           Anthony Morrow     41       6      87            9
    ## 103             Bobby Portis    437      35    1000           64
    ## 104            Cameron Payne     54      15     142           11
    ## 105        Cristiano Felicio    316      40    1040           66
    ## 106         Denzel Valentine    291      63     976           57
    ## 107              Dwyane Wade   1096     229    1792           60
    ## 108            Isaiah Canaan    181      37     592           39
    ## 109             Jerian Grant    370     120    1028           63
    ## 110             Jimmy Butler   1816     417    2809           76
    ## 111        Joffrey Lauvergne     89      19     241           20
    ## 112  Michael Carter-Williams    297     113     846           45
    ## 113           Nikola Mirotic    744      75    1679           70
    ## 114              Paul Zipser    240      36     843           44
    ## 115              Rajon Rondo    538     461    1843           69
    ## 116              Robin Lopez    839      80    2271           81
    ## 117             Dion Waiters    729     200    1384           46
    ## 118             Goran Dragic   1483     423    2459           73
    ## 119         Hassan Whiteside   1309      57    2513           77
    ## 120            James Johnson    975     276    2085           76
    ## 121           Josh McRoberts    107      50     381           22
    ## 122          Josh Richardson    539     140    1614           53
    ## 123          Justise Winslow    196      66     625           18
    ## 124             Luke Babbitt    324      36    1065           68
    ## 125              Okaro White     98      21     471           35
    ## 126          Rodney McGruder    497     124    1966           78
    ## 127            Tyler Johnson   1002     233    2178           73
    ## 128            Udonis Haslem     31       6     130           17
    ## 129          Wayne Ellington    648      70    1500           62
    ## 130              Willie Reed    374      26    1031           71
    ## 131           Andre Drummond   1105      89    2409           81
    ## 132              Aron Baynes    365      32    1163           75
    ## 133               Beno Udrih    227     131     560           39
    ## 134         Boban Marjanovic    191       9     293           35
    ## 135          Darrun Hilliard    127      33     381           39
    ## 136           Henry Ellenson     60       7     146           19
    ## 137                Ish Smith    758     418    1955           81
    ## 138                Jon Leuer    767     111    1944           75
    ## 139 Kentavious Caldwell-Pope   1047     193    2529           76
    ## 140            Marcus Morris   1105     160    2565           79
    ## 141          Michael Gbinije      4       2      32            9
    ## 142           Reggie Bullock    141      29     467           31
    ## 143           Reggie Jackson    752     270    1424           52
    ## 144          Stanley Johnson    339     105    1371           77
    ## 145            Tobias Harris   1321     142    2567           82
    ## 146            Brian Roberts    142      52     416           41
    ## 147            Briante Weber     50      16     159           13
    ## 148           Christian Wood     35       2     107           13
    ## 149              Cody Zeller    639      99    1725           62
    ## 150           Frank Kaminsky    874     162    1954           75
    ## 151              Jeremy Lamb    603      75    1143           62
    ## 152          Johnny O'Bryant     18       4      34            4
    ## 153             Kemba Walker   1830     435    2739           79
    ## 154          Marco Belinelli    780     147    1778           74
    ## 155          Marvin Williams    849     106    2295           76
    ## 156   Michael Kidd-Gilchrist    743     114    2349           81
    ## 157            Miles Plumlee     31       3     174           13
    ## 158            Nicolas Batum   1164     455    2617           77
    ## 159           Ramon Sessions    312     129     811           50
    ## 160           Treveon Graham     57       6     189           27
    ## 161          Carmelo Anthony   1659     213    2538           74
    ## 162           Chasson Randle     95      28     225           18
    ## 163             Courtney Lee    835     179    2459           77
    ## 164             Derrick Rose   1154     283    2082           64
    ## 165              Joakim Noah    232     103    1015           46
    ## 166           Justin Holiday    629     102    1639           82
    ## 167       Kristaps Porzingis   1196      97    2164           66
    ## 168             Kyle O'Quinn    496     117    1229           79
    ## 169             Lance Thomas    275      35     968           46
    ## 170         Marshall Plumlee     40      10     170           21
    ## 171            Maurice Ndour     98       8     331           32
    ## 172     Mindaugas Kuzminskas    425      69    1016           68
    ## 173                Ron Baker    215     107     857           52
    ## 174            Sasha Vujacic    124      52     408           42
    ## 175        Willy Hernangomez    587      96    1324           72
    ## 176             Aaron Gordon   1019     150    2298           80
    ## 177          Bismack Biyombo    483      74    1793           81
    ## 178              C.J. Watson    281     114    1012           62
    ## 179            D.J. Augustin    616     209    1538           78
    ## 180             Damjan Rudez     82      20     314           45
    ## 181            Elfrid Payton   1046     529    2412           82
    ## 182            Evan Fournier   1167     202    2234           68
    ## 183               Jeff Green    638      81    1534           69
    ## 184              Jodie Meeks    327      45     738           36
    ## 185      Marcus Georges-Hunt     14       3      48            5
    ## 186            Mario Hezonja    317      62     960           65
    ## 187           Nikola Vucevic   1096     208    2163           75
    ## 188          Patricio Garino      0       0      43            5
    ## 189        Stephen Zimmerman     23       4     108           19
    ## 190            Terrence Ross    299      43     748           24
    ## 191           Alex Poythress     64       5     157            6
    ## 192              Dario Saric   1040     182    2129           81
    ## 193         Gerald Henderson    662     112    1667           72
    ## 194            Jahlil Okafor    590      58    1134           50
    ## 195           Jerryd Bayless     33      13      71            3
    ## 196              Joel Embiid    627      66     786           31
    ## 197          Justin Anderson    203      34     518           24
    ## 198             Nik Stauskas    756     188    2188           80
    ## 199           Richaun Holmes    559      58    1193           57
    ## 200         Robert Covington    864     102    2119           67
    ## 201         Sergio Rodriguez    530     344    1518           68
    ## 202               Shawn Long    148      13     234           18
    ## 203           T.J. McConnell    556     534    2133           81
    ## 204           Tiago Splitter     39       4      76            8
    ## 205  Timothe Luwawu-Cabarrot    445      75    1190           69
    ## 206         Andrew Nicholson     30       3     111           10
    ## 207           Archie Goodwin     95      23     184           12
    ## 208              Brook Lopez   1539     176    2222           75
    ## 209             Caris LeVert    468     110    1237           57
    ## 210         Isaiah Whitehead    543     192    1643           73
    ## 211               Jeremy Lin    523     184     883           36
    ## 212               Joe Harris    428      54    1138           52
    ## 213          Justin Hamilton    442      55    1177           64
    ## 214           K.J. McDaniels    126       9     293           20
    ## 215               Quincy Acy    209      18     510           32
    ## 216               Randy Foye    357     135    1284           69
    ## 217  Rondae Hollis-Jefferson    675     154    1761           78
    ## 218          Sean Kilpatrick    919     157    1754           70
    ## 219        Spencer Dinwiddie    432     185    1334           59
    ## 220            Trevor Booker    709     138    1754           71
    ## 221           Andre Iguodala    574     262    1998           76
    ## 222             Damian Jones     19       0      85           10
    ## 223               David West    316     151     854           68
    ## 224           Draymond Green    776     533    2471           76
    ## 225                Ian Clark    527      90    1137           77
    ## 226     James Michael McAdoo    147      17     457           52
    ## 227             JaVale McGee    472      17     739           77
    ## 228             Kevin Durant   1555     300    2070           62
    ## 229             Kevon Looney    135      29     447           53
    ## 230            Klay Thompson   1742     160    2649           78
    ## 231              Matt Barnes    114      45     410           20
    ## 232            Patrick McCaw    282      77    1074           71
    ## 233         Shaun Livingston    389     139    1345           76
    ## 234            Stephen Curry   1999     523    2638           79
    ## 235            Zaza Pachulia    426     132    1268           70
    ## 236              Bryn Forbes     94      23     285           36
    ## 237              Danny Green    497     124    1807           68
    ## 238                David Lee    576     124    1477           79
    ## 239            Davis Bertans    303      46     808           67
    ## 240          Dejounte Murray    130      48     322           38
    ## 241           Dewayne Dedmon    387      44    1330           76
    ## 242             Joel Anthony     25       3     122           19
    ## 243         Jonathon Simmons    483     126    1392           78
    ## 244            Kawhi Leonard   1888     260    2474           74
    ## 245            Kyle Anderson    246      91    1020           72
    ## 246        LaMarcus Aldridge   1243     139    2335           72
    ## 247            Manu Ginobili    517     183    1291           69
    ## 248              Patty Mills    759     280    1754           80
    ## 249                Pau Gasol    792     150    1627           64
    ## 250              Tony Parker    638     285    1587           63
    ## 251              Bobby Brown     62      14     123           25
    ## 252           Chinanu Onuaku     14       3      52            5
    ## 253             Clint Capela    818      64    1551           65
    ## 254              Eric Gordon   1217     188    2323           75
    ## 255            Isaiah Taylor      3       3      52            4
    ## 256             James Harden   2356     906    2947           81
    ## 257             Kyle Wiltjer     13       2      44           14
    ## 258             Lou Williams    343      56     591           23
    ## 259         Montrezl Harrell    527      64    1064           58
    ## 260         Patrick Beverley    639     281    2058           67
    ## 261            Ryan Anderson    979      68    2116           72
    ## 262               Sam Dekker    504      76    1419           77
    ## 263             Trevor Ariza    936     175    2773           80
    ## 264            Troy Williams     58       6     139            6
    ## 265            Alan Anderson     86      11     308           30
    ## 266            Austin Rivers    889     204    2054           74
    ## 267            Blake Griffin   1316     300    2076           61
    ## 268             Brandon Bass    292      21     577           52
    ## 269            Brice Johnson      4       1       9            3
    ## 270               Chris Paul   1104     563    1921           61
    ## 271           DeAndre Jordan   1029      96    2570           81
    ## 272            Diamond Stone     10       0      24            7
    ## 273              J.J. Redick   1173     110    2198           78
    ## 274           Jamal Crawford   1008     213    2157           82
    ## 275         Luc Mbah a Moute    484      39    1787           80
    ## 276        Marreese Speights    711      66    1286           82
    ## 277              Paul Pierce     81      10     277           25
    ## 278           Raymond Felton    538     191    1700           80
    ## 279           Wesley Johnson    186      23     810           68
    ## 280               Alec Burks    283      30     653           42
    ## 281               Boris Diaw    338     170    1283           73
    ## 282               Dante Exum    412     112    1228           66
    ## 283           Derrick Favors    476      56    1186           50
    ## 284              George Hill    829     203    1544           49
    ## 285           Gordon Hayward   1601     252    2516           73
    ## 286              Jeff Withey    146       7     432           51
    ## 287               Joe Ingles    581     224    1972           82
    ## 288              Joe Johnson    715     144    1843           78
    ## 289            Joel Bolomboy     22       2      53           12
    ## 290                Raul Neto    100      34     346           40
    ## 291              Rodney Hood    748      96    1593           59
    ## 292              Rudy Gobert   1137      97    2744           81
    ## 293             Shelvin Mack    430     154    1205           55
    ## 294               Trey Lyles    440      70    1158           71
    ## 295             Alex Abrines    406      40    1055           68
    ## 296           Andre Roberson    522      79    2376           79
    ## 297         Domantas Sabonis    479      82    1632           81
    ## 298           Doug McDermott    145      13     430           22
    ## 299              Enes Kanter   1033      67    1533           72
    ## 300             Jerami Grant    421      46    1490           78
    ## 301             Josh Huestis     14       3      31            2
    ## 302             Kyle Singler     88       9     385           32
    ## 303            Nick Collison     33      12     128           20
    ## 304              Norris Cole     43      14     125           13
    ## 305        Russell Westbrook   2558     840    2802           81
    ## 306           Semaj Christon    183     130     973           64
    ## 307             Steven Adams    905      86    2389           80
    ## 308               Taj Gibson    207      13     487           23
    ## 309           Victor Oladipo   1067     176    2222           67
    ## 310          Andrew Harrison    425     198    1474           72
    ## 311           Brandan Wright    189      15     447           28
    ## 312         Chandler Parsons    210      55     675           34
    ## 313            Deyonta Davis     58       2     238           36
    ## 314              James Ennis    429      64    1501           64
    ## 315           JaMychal Green    689      84    2101           77
    ## 316            Jarell Martin    165       8     558           42
    ## 317               Marc Gasol   1446     338    2531           74
    ## 318              Mike Conley   1415     433    2292           69
    ## 319               Tony Allen    643      98    1914           71
    ## 320             Troy Daniels    551      46    1183           67
    ## 321             Vince Carter    586     133    1799           73
    ## 322             Wade Baldwin    106      61     405           33
    ## 323             Wayne Selden     55      12     189           11
    ## 324            Zach Randolph   1028     122    1786           73
    ## 325          Al-Farouq Aminu    532      99    1773           61
    ## 326             Allen Crabbe    845      93    2254           79
    ## 327            C.J. McCollum   1837     285    2796           80
    ## 328           Damian Lillard   2024     439    2694           75
    ## 329                 Ed Davis    200      27     789           46
    ## 330              Evan Turner    586     205    1658           65
    ## 331              Jake Layman     78      11     249           35
    ## 332             Jusuf Nurkic    304      63     584           20
    ## 333         Maurice Harkless    773      89    2223           77
    ## 334           Meyers Leonard    401      71    1222           74
    ## 335              Noah Vonleh    327      31    1265           74
    ## 336          Pat Connaughton     98      28     316           39
    ## 337           Shabazz Napier    218      67     512           53
    ## 338           Tim Quarterman     31      11      80           16
    ## 339         Danilo Gallinari   1145     136    2134           63
    ## 340           Darrell Arthur    262      42     639           41
    ## 341          Emmanuel Mudiay    603     217    1406           55
    ## 342              Gary Harris    851     164    1782           57
    ## 343             Jamal Murray    811     170    1764           82
    ## 344            Jameer Nelson    687     385    2045           75
    ## 345         Juan Hernangomez    305      29     842           62
    ## 346           Kenneth Faried    587      55    1296           61
    ## 347            Malik Beasley     83      11     165           22
    ## 348            Mason Plumlee    245      70     632           27
    ## 349              Mike Miller     28      22     151           20
    ## 350             Nikola Jokic   1221     358    2038           73
    ## 351              Roy Hibbert      4       1      11            6
    ## 352              Will Barton    820     206    1705           60
    ## 353          Wilson Chandler   1117     143    2197           71
    ## 354            Alexis Ajinca    207      12     584           39
    ## 355            Anthony Davis   2099     157    2708           75
    ## 356             Axel Toupane     11       0      41            2
    ## 357            Cheick Diallo     87       4     199           17
    ## 358         Dante Cunningham    435      36    1649           66
    ## 359         DeMarcus Cousins    414      66     574           17
    ## 360       Donatas Motiejunas    150      34     479           34
    ## 361            E'Twaun Moore    700     164    1820           73
    ## 362          Jordan Crawford    267      57     442           19
    ## 363             Jrue Holiday   1029     488    2190           67
    ## 364                Omer Asik     85      15     482           31
    ## 365               Quinn Cook     52      14     111            9
    ## 366             Solomon Hill    563     141    2374           80
    ## 367              Tim Frazier    464     335    1525           65
    ## 368             A.J. Hammons     48       4     163           22
    ## 369          DeAndre Liggins      8       0      25            1
    ## 370             Devin Harris    437     136    1087           65
    ## 371            Dirk Nowitzki    769      82    1424           54
    ## 372      Dorian Finney-Smith    350      67    1642           81
    ## 373            Dwight Powell    516      49    1333           77
    ## 374          Harrison Barnes   1518     117    2803           79
    ## 375               J.J. Barea    381     193     771           35
    ## 376            Jarrod Uthoff     40       9     115            9
    ## 377             Nerlens Noel    188      20     483           22
    ## 378         Nicolas Brussino    150      47     521           54
    ## 379              Salah Mejri    213      14     905           73
    ## 380               Seth Curry    898     188    2029           70
    ## 381          Wesley Matthews    986     210    2495           73
    ## 382             Yogi Ferrell    408     155    1046           36
    ## 383         Anthony Tolliver    461      77    1477           65
    ## 384            Arron Afflalo    515      78    1580           61
    ## 385             Ben McLemore    495      51    1176           61
    ## 386              Buddy Hield    378      44     727           25
    ## 387          Darren Collison    900     312    2063           68
    ## 388           Garrett Temple    506     169    1728           65
    ## 389     Georgios Papagiannis    124      20     355           22
    ## 390             Kosta Koufos    470      47    1419           71
    ## 391        Langston Galloway    114      28     375           19
    ## 392       Malachi Richardson     79      11     198           22
    ## 393                 Rudy Gay    562      82    1013           30
    ## 394          Skal Labissiere    289      27     612           33
    ## 395                Ty Lawson    681     335    1732           69
    ## 396             Tyreke Evans    163      33     314           14
    ## 397      Willie Cauley-Stein    611      80    1421           75
    ## 398            Adreian Payne     63       7     135           18
    ## 399           Andrew Wiggins   1933     189    3048           82
    ## 400             Brandon Rush    197      45    1030           47
    ## 401             Cole Aldrich    105      25     531           62
    ## 402             Gorgui Dieng    816     158    2653           82
    ## 403              Jordan Hill     12       0      47            7
    ## 404       Karl-Anthony Towns   2061     220    3030           82
    ## 405                Kris Dunn    293     188    1333           78
    ## 406          Nemanja Bjelica    403      79    1190           65
    ## 407              Omri Casspi     45      11     222           13
    ## 408              Ricky Rubio    836     682    2469           75
    ## 409         Shabazz Muhammad    772      35    1516           78
    ## 410               Tyus Jones    209     156     774           60
    ## 411              Zach LaVine    889     139    1749           47
    ## 412           Brandon Ingram    740     166    2279           79
    ## 413             Corey Brewer    129      36     358           24
    ## 414         D'Angelo Russell    984     303    1811           63
    ## 415              David Nwaba    120      14     397           20
    ## 416              Ivica Zubac    284      30     609           38
    ## 417          Jordan Clarkson   1205     213    2397           82
    ## 418            Julius Randle    975     264    2132           74
    ## 419          Larry Nance Jr.    449      96    1442           63
    ## 420                Luol Deng    425      74    1486           56
    ## 421        Metta World Peace     57      11     160           25
    ## 422               Nick Young    791      58    1556           60
    ## 423              Tarik Black    383      39    1091           67
    ## 424          Thomas Robinson    241      31     560           48
    ## 425           Timofey Mozgov    401      43    1104           54
    ## 426              Tyler Ennis    170      52     392           22
    ## 427            Alan Williams    346      23     708           47
    ## 428                 Alex Len    613      44    1560           77
    ## 429           Brandon Knight    595     130    1140           54
    ## 430            Derrick Jones    168      12     545           32
    ## 431             Devin Booker   1726     268    2730           78
    ## 432            Dragan Bender    146      23     574           43
    ## 433           Elijah Millsap      3       1      23            2
    ## 434             Eric Bledsoe   1390     418    2176           66
    ## 435             Jared Dudley    434     121    1362           64
    ## 436          Leandro Barbosa    419      81     963           67
    ## 437          Marquese Chriss    753      60    1743           82
    ## 438             Ronnie Price     14      18     134           14
    ## 439              T.J. Warren    951      75    2048           66
    ## 440               Tyler Ulis    444     226    1123           61
    ## 441           Tyson Chandler    397      30    1298           47

Yet, we want more essential data to come from another source also!

``` r
github <- "https://github.com/ucb-stat133/stat133-fall-2017/raw/master/"
csv <- "data/nba2017-roster.csv"
download.file(url = paste0(github, csv), destfile = 'nba2017-roster.csv')
dat1 <- read.csv('nba2017-roster.csv', stringsAsFactors = FALSE)
```

``` r
dat1
```

    ##                       player team position height weight age experience
    ## 1               A.J. Hammons  DAL        C     84    260  24          0
    ## 2               Aaron Brooks  IND       PG     72    161  32          8
    ## 3               Aaron Gordon  ORL       SF     81    220  21          2
    ## 4              Adreian Payne  MIN       PF     82    237  25          2
    ## 5                 Al Horford  BOS        C     82    245  30          9
    ## 6               Al Jefferson  IND        C     82    289  32         12
    ## 7            Al-Farouq Aminu  POR       SF     81    220  26          6
    ## 8              Alan Anderson  LAC       SF     78    220  34          7
    ## 9              Alan Williams  PHO        C     80    260  24          1
    ## 10                Alec Burks  UTA       SG     78    214  25          5
    ## 11              Alex Abrines  OKC       SG     78    190  23          0
    ## 12                  Alex Len  PHO        C     85    260  23          3
    ## 13            Alex Poythress  PHI       PF     79    238  23          0
    ## 14             Alexis Ajinca  NOP        C     86    248  28          6
    ## 15              Allen Crabbe  POR       SG     78    210  24          3
    ## 16              Amir Johnson  BOS       PF     81    240  29         11
    ## 17            Andre Drummond  DET        C     83    279  23          4
    ## 18            Andre Iguodala  GSW       SF     78    215  33         12
    ## 19            Andre Roberson  OKC       SF     79    210  25          3
    ## 20           Andrew Harrison  MEM       PG     78    213  22          0
    ## 21          Andrew Nicholson  BRK       PF     81    250  27          4
    ## 22            Andrew Wiggins  MIN       SF     80    199  21          2
    ## 23             Anthony Davis  NOP        C     82    253  23          4
    ## 24            Anthony Morrow  CHI       SG     77    210  31          8
    ## 25          Anthony Tolliver  SAC       PF     80    240  31          8
    ## 26            Archie Goodwin  BRK       SG     77    200  22          3
    ## 27               Aron Baynes  DET        C     82    260  30          4
    ## 28             Arron Afflalo  SAC       SG     77    210  31          9
    ## 29             Austin Rivers  LAC       SG     76    200  24          4
    ## 30             Avery Bradley  BOS       SG     74    180  26          6
    ## 31              Axel Toupane  NOP       SF     79    197  24          1
    ## 32              Ben McLemore  SAC       SG     77    195  23          3
    ## 33                Beno Udrih  DET       PG     75    205  34         12
    ## 34           Bismack Biyombo  ORL        C     81    255  24          5
    ## 35             Blake Griffin  LAC       PF     82    251  27          6
    ## 36          Boban Marjanovic  DET        C     87    290  28          1
    ## 37               Bobby Brown  HOU       PG     74    175  32          2
    ## 38              Bobby Portis  CHI       PF     83    230  21          1
    ## 39          Bojan Bogdanovic  WAS       SF     80    216  27          2
    ## 40                Boris Diaw  UTA       PF     80    250  34         13
    ## 41              Bradley Beal  WAS       SG     77    207  23          4
    ## 42            Brandan Wright  MEM       PF     82    210  29          8
    ## 43              Brandon Bass  LAC       PF     80    250  31         11
    ## 44            Brandon Ingram  LAL       SF     81    190  19          0
    ## 45          Brandon Jennings  WAS       PG     73    170  27          7
    ## 46            Brandon Knight  PHO       SG     75    189  25          5
    ## 47              Brandon Rush  MIN       SG     78    220  31          8
    ## 48             Brian Roberts  CHO       PG     73    173  31          4
    ## 49             Briante Weber  CHO       PG     74    165  24          1
    ## 50             Brice Johnson  LAC       PF     82    230  22          0
    ## 51               Brook Lopez  BRK        C     84    275  28          8
    ## 52             Bruno Caboclo  TOR       SF     81    218  21          2
    ## 53               Bryn Forbes  SAS       SG     75    190  23          0
    ## 54               Buddy Hield  SAC       SG     76    214  23          0
    ## 55             C.J. McCollum  POR       SG     76    200  25          3
    ## 56                C.J. Miles  IND       SF     78    225  29         11
    ## 57               C.J. Watson  ORL       PG     74    175  32          9
    ## 58             Cameron Payne  CHI       PG     75    185  22          1
    ## 59              Caris LeVert  BRK       SF     79    203  22          0
    ## 60           Carmelo Anthony  NYK       SF     80    240  32         13
    ## 61          Chandler Parsons  MEM       SF     82    230  28          5
    ## 62             Channing Frye  CLE        C     83    255  33         10
    ## 63            Chasson Randle  NYK       PG     74    185  23          0
    ## 64             Cheick Diallo  NOP       PF     81    220  20          0
    ## 65            Chinanu Onuaku  HOU        C     82    245  20          0
    ## 66          Chris McCullough  WAS       PF     83    200  21          1
    ## 67                Chris Paul  LAC       PG     72    175  31         11
    ## 68            Christian Wood  CHO       PF     83    220  21          1
    ## 69              Clint Capela  HOU        C     82    240  22          2
    ## 70               Cody Zeller  CHO       PF     84    240  24          3
    ## 71              Cole Aldrich  MIN        C     83    250  28          6
    ## 72              Corey Brewer  LAL       SF     81    186  30          9
    ## 73               Cory Joseph  TOR       SG     75    193  25          5
    ## 74              Courtney Lee  NYK       SG     77    200  31          8
    ## 75         Cristiano Felicio  CHI        C     82    275  24          1
    ## 76             D.J. Augustin  ORL       PG     72    183  29          8
    ## 77          D'Angelo Russell  LAL       PG     77    195  20          1
    ## 78             Dahntay Jones  CLE       SF     78    225  36         12
    ## 79              Damian Jones  GSW        C     84    245  21          0
    ## 80            Damian Lillard  POR       PG     75    195  26          4
    ## 81              Damjan Rudez  ORL       SF     82    228  30          2
    ## 82             Daniel Ochefu  WAS        C     83    245  23          0
    ## 83          Danilo Gallinari  DEN       SF     82    225  28          7
    ## 84               Danny Green  SAS       SG     78    215  29          7
    ## 85          Dante Cunningham  NOP       SF     80    230  29          7
    ## 86                Dante Exum  UTA       PG     78    190  21          1
    ## 87               Dario Saric  PHI       PF     82    223  22          0
    ## 88            Darrell Arthur  DEN       PF     81    235  28          7
    ## 89           Darren Collison  SAC       PG     72    175  29          7
    ## 90           Darrun Hilliard  DET       SG     78    205  23          1
    ## 91                 David Lee  SAS       PF     81    245  33         11
    ## 92               David Nwaba  LAL       SG     76    209  24          0
    ## 93                David West  GSW        C     81    250  36         13
    ## 94             Davis Bertans  SAS       PF     82    210  24          0
    ## 95            DeAndre Jordan  LAC        C     83    265  28          8
    ## 96           DeAndre Liggins  DAL       SG     78    209  28          3
    ## 97           DeAndre' Bembry  ATL       SF     78    210  22          0
    ## 98           Dejounte Murray  SAS       PG     77    170  20          0
    ## 99              Delon Wright  TOR       PG     77    183  24          1
    ## 100            DeMar DeRozan  TOR       SG     79    221  27          7
    ## 101         DeMarcus Cousins  NOP        C     83    270  26          6
    ## 102          DeMarre Carroll  TOR       SF     80    215  30          7
    ## 103        Demetrius Jackson  BOS       PG     73    201  22          0
    ## 104          Dennis Schroder  ATL       PG     73    172  23          3
    ## 105         Denzel Valentine  CHI       SG     78    212  23          0
    ## 106           Deron Williams  CLE       PG     75    200  32         11
    ## 107           Derrick Favors  UTA       PF     82    265  25          6
    ## 108            Derrick Jones  PHO       SF     79    190  19          0
    ## 109             Derrick Rose  NYK       PG     75    190  28          7
    ## 110         Derrick Williams  CLE       PF     80    240  25          5
    ## 111             Devin Booker  PHO       SG     78    206  20          1
    ## 112             Devin Harris  DAL       PG     75    192  33         12
    ## 113           Dewayne Dedmon  SAS        C     84    245  27          3
    ## 114            Deyonta Davis  MEM        C     83    237  20          0
    ## 115            Diamond Stone  LAC        C     83    255  19          0
    ## 116             Dion Waiters  MIA       SG     76    225  25          4
    ## 117            Dirk Nowitzki  DAL       PF     84    245  38         18
    ## 118         Domantas Sabonis  OKC       PF     83    240  20          0
    ## 119       Donatas Motiejunas  NOP       PF     84    222  26          4
    ## 120      Dorian Finney-Smith  DAL       PF     80    220  23          0
    ## 121           Doug McDermott  OKC       SF     80    225  25          2
    ## 122            Dragan Bender  PHO       PF     85    225  19          0
    ## 123           Draymond Green  GSW       PF     79    230  26          4
    ## 124            Dwight Howard  ATL        C     83    265  31         12
    ## 125            Dwight Powell  DAL        C     83    240  25          2
    ## 126              Dwyane Wade  CHI       SG     76    220  35         13
    ## 127            E'Twaun Moore  NOP       SG     76    191  27          5
    ## 128                 Ed Davis  POR       PF     82    240  27          6
    ## 129              Edy Tavares  CLE        C     87    260  24          1
    ## 130            Elfrid Payton  ORL       PG     76    185  22          2
    ## 131           Elijah Millsap  PHO       SG     78    225  29          2
    ## 132          Emmanuel Mudiay  DEN       PG     77    200  20          1
    ## 133              Enes Kanter  OKC        C     83    245  24          5
    ## 134             Eric Bledsoe  PHO       PG     73    190  27          6
    ## 135              Eric Gordon  HOU       SG     76    215  28          8
    ## 136           Ersan Ilyasova  ATL       PF     82    235  29          8
    ## 137            Evan Fournier  ORL       SG     79    205  24          4
    ## 138              Evan Turner  POR       SF     79    220  28          6
    ## 139           Frank Kaminsky  CHO        C     84    242  23          1
    ## 140            Fred VanVleet  TOR       PG     72    195  22          0
    ## 141           Garrett Temple  SAC       SG     78    195  30          6
    ## 142              Gary Harris  DEN       SG     76    210  22          2
    ## 143              George Hill  UTA       PG     75    188  30          8
    ## 144            Georges Niang  IND       PF     80    230  23          0
    ## 145     Georgios Papagiannis  SAC        C     85    240  19          0
    ## 146             Gerald Green  BOS       SF     79    205  31          9
    ## 147         Gerald Henderson  PHI       SG     77    215  29          7
    ## 148    Giannis Antetokounmpo  MIL       SF     83    222  22          3
    ## 149             Goran Dragic  MIA       PG     75    190  30          8
    ## 150           Gordon Hayward  UTA       SF     80    226  26          6
    ## 151             Gorgui Dieng  MIN       PF     83    241  27          3
    ## 152              Greg Monroe  MIL        C     83    265  26          6
    ## 153          Harrison Barnes  DAL       PF     80    210  24          4
    ## 154         Hassan Whiteside  MIA        C     84    265  27          4
    ## 155           Henry Ellenson  DET       PF     83    245  20          0
    ## 156                Ian Clark  GSW       SG     75    175  25          3
    ## 157              Ian Mahinmi  WAS        C     83    250  30          8
    ## 158            Iman Shumpert  CLE       SG     77    220  26          5
    ## 159            Isaiah Canaan  CHI       SG     72    201  25          3
    ## 160            Isaiah Taylor  HOU       PG     75    170  22          0
    ## 161            Isaiah Thomas  BOS       PG     69    185  27          5
    ## 162         Isaiah Whitehead  BRK       PG     76    213  21          0
    ## 163                Ish Smith  DET       PG     72    175  28          6
    ## 164              Ivica Zubac  LAL        C     85    265  19          0
    ## 165               J.J. Barea  DAL       PG     72    185  32         10
    ## 166              J.J. Redick  LAC       SG     76    190  32         10
    ## 167               J.R. Smith  CLE       SG     78    225  31         12
    ## 168            Jabari Parker  MIL       PF     80    250  21          2
    ## 169              Jae Crowder  BOS       SF     78    235  26          4
    ## 170            Jahlil Okafor  PHI        C     83    275  21          1
    ## 171              Jake Layman  POR       SF     81    210  22          0
    ## 172             Jakob Poeltl  TOR        C     84    248  21          0
    ## 173           Jamal Crawford  LAC       SG     77    200  36         16
    ## 174             Jamal Murray  DEN       SG     76    207  19          0
    ## 175            Jameer Nelson  DEN       PG     72    190  34         12
    ## 176              James Ennis  MEM       SF     79    210  26          2
    ## 177             James Harden  HOU       PG     77    220  27          7
    ## 178            James Johnson  MIA       PF     81    250  29          7
    ## 179              James Jones  CLE       SF     80    218  36         13
    ## 180     James Michael McAdoo  GSW       PF     81    230  24          2
    ## 181              James Young  BOS       SG     78    215  21          2
    ## 182           JaMychal Green  MEM       PF     81    227  26          2
    ## 183             Jared Dudley  PHO       PF     79    225  31          9
    ## 184            Jarell Martin  MEM       PF     82    239  22          1
    ## 185            Jarrod Uthoff  DAL       PF     81    221  23          0
    ## 186              Jason Smith  WAS        C     84    245  30          8
    ## 187              Jason Terry  MIL       SG     74    185  39         17
    ## 188             JaVale McGee  GSW        C     84    270  29          8
    ## 189             Jaylen Brown  BOS       SF     79    225  20          0
    ## 190               Jeff Green  ORL       PF     81    235  30          8
    ## 191              Jeff Teague  IND       PG     74    186  28          7
    ## 192              Jeff Withey  UTA        C     84    231  26          3
    ## 193             Jerami Grant  OKC       SF     80    210  22          2
    ## 194              Jeremy Lamb  CHO       SG     77    185  24          4
    ## 195               Jeremy Lin  BRK       PG     75    200  28          6
    ## 196             Jerian Grant  CHI       PG     76    195  24          1
    ## 197           Jerryd Bayless  PHI       PG     75    200  28          8
    ## 198             Jimmy Butler  CHI       SF     79    220  27          5
    ## 199              Joakim Noah  NYK        C     83    230  31          9
    ## 200              Jodie Meeks  ORL       SG     76    210  29          7
    ## 201               Joe Harris  BRK       SG     78    219  25          2
    ## 202               Joe Ingles  UTA       SF     80    226  29          2
    ## 203              Joe Johnson  UTA       SF     79    240  35         15
    ## 204                Joe Young  IND       PG     74    180  24          1
    ## 205             Joel Anthony  SAS        C     81    245  34          9
    ## 206            Joel Bolomboy  UTA       PF     81    235  23          0
    ## 207              Joel Embiid  PHI        C     84    250  22          0
    ## 208        Joffrey Lauvergne  CHI        C     83    220  25          2
    ## 209              John Henson  MIL        C     83    229  26          4
    ## 210                John Wall  WAS       PG     76    195  26          6
    ## 211          Johnny O'Bryant  CHO       PF     81    257  23          2
    ## 212                Jon Leuer  DET       PF     82    228  27          5
    ## 213            Jonas Jerebko  BOS       PF     82    231  29          6
    ## 214        Jonas Valanciunas  TOR        C     84    265  24          4
    ## 215         Jonathon Simmons  SAS       SG     78    195  27          1
    ## 216          Jordan Clarkson  LAL       SG     77    194  24          2
    ## 217          Jordan Crawford  NOP       SG     76    195  28          4
    ## 218              Jordan Hill  MIN        C     82    235  29          7
    ## 219            Jordan Mickey  BOS       PF     80    235  22          1
    ## 220            Jose Calderon  ATL       PG     75    200  35         11
    ## 221             Josh Huestis  OKC       PF     79    230  25          1
    ## 222           Josh McRoberts  MIA       PF     82    240  29          9
    ## 223          Josh Richardson  MIA       SG     78    200  23          1
    ## 224             Jrue Holiday  NOP       PG     76    205  26          7
    ## 225         Juan Hernangomez  DEN       PF     81    230  21          0
    ## 226            Julius Randle  LAL       PF     81    250  22          2
    ## 227          Justin Anderson  PHI       SF     78    228  23          1
    ## 228          Justin Hamilton  BRK        C     84    260  26          2
    ## 229           Justin Holiday  NYK       SG     78    185  27          3
    ## 230          Justise Winslow  MIA       SF     79    225  20          1
    ## 231             Jusuf Nurkic  POR        C     84    280  22          2
    ## 232           K.J. McDaniels  BRK       SF     78    205  23          2
    ## 233       Karl-Anthony Towns  MIN        C     84    244  21          1
    ## 234            Kawhi Leonard  SAS       SF     79    230  25          5
    ## 235               Kay Felder  CLE       PG     69    176  21          0
    ## 236             Kelly Olynyk  BOS        C     84    238  25          3
    ## 237             Kemba Walker  CHO       PG     73    172  26          5
    ## 238           Kenneth Faried  DEN       PF     80    228  27          5
    ## 239            Kent Bazemore  ATL       SF     77    201  27          4
    ## 240 Kentavious Caldwell-Pope  DET       SG     77    205  23          3
    ## 241             Kevin Durant  GSW       SF     81    240  28          9
    ## 242               Kevin Love  CLE       PF     82    251  28          8
    ## 243           Kevin Seraphin  IND       PF     81    285  27          6
    ## 244             Kevon Looney  GSW        C     81    220  20          1
    ## 245          Khris Middleton  MIL       SF     80    234  25          4
    ## 246            Klay Thompson  GSW       SG     79    215  26          5
    ## 247             Kosta Koufos  SAC        C     84    265  27          8
    ## 248                Kris Dunn  MIN       PG     76    210  22          0
    ## 249           Kris Humphries  ATL       PF     81    235  31         12
    ## 250       Kristaps Porzingis  NYK       PF     87    240  21          1
    ## 251            Kyle Anderson  SAS       SG     81    230  23          2
    ## 252              Kyle Korver  CLE       SG     79    212  35         13
    ## 253               Kyle Lowry  TOR       PG     72    205  30         10
    ## 254             Kyle O'Quinn  NYK        C     82    250  26          4
    ## 255             Kyle Singler  OKC       SF     80    228  28          4
    ## 256             Kyle Wiltjer  HOU       PF     82    240  24          0
    ## 257             Kyrie Irving  CLE       PG     75    193  24          5
    ## 258        LaMarcus Aldridge  SAS       PF     83    260  31         10
    ## 259         Lance Stephenson  IND       SG     77    230  26          6
    ## 260             Lance Thomas  NYK       PF     80    235  28          5
    ## 261        Langston Galloway  SAC       PG     74    200  25          2
    ## 262          Larry Nance Jr.  LAL       PF     81    230  24          1
    ## 263              Lavoy Allen  IND       PF     81    260  27          5
    ## 264          Leandro Barbosa  PHO       SG     75    194  34         13
    ## 265             LeBron James  CLE       SF     80    250  32         13
    ## 266             Lou Williams  HOU       SG     73    175  30         11
    ## 267         Luc Mbah a Moute  LAC       SF     80    230  30          8
    ## 268           Lucas Nogueira  TOR        C     84    241  24          2
    ## 269             Luke Babbitt  MIA       SF     81    225  27          6
    ## 270                Luol Deng  LAL       SF     81    220  31         12
    ## 271       Malachi Richardson  SAC       SG     78    205  21          0
    ## 272          Malcolm Brogdon  MIL       SG     77    215  24          0
    ## 273          Malcolm Delaney  ATL       PG     75    190  27          0
    ## 274            Malik Beasley  DEN       SG     77    196  20          0
    ## 275            Manu Ginobili  SAS       SG     78    205  39         14
    ## 276               Marc Gasol  MEM        C     85    255  32          8
    ## 277            Marcin Gortat  WAS        C     83    240  32          9
    ## 278          Marco Belinelli  CHO       SG     77    210  30          9
    ## 279      Marcus Georges-Hunt  ORL       SG     77    216  22          0
    ## 280            Marcus Morris  DET       SF     81    235  27          5
    ## 281             Marcus Smart  BOS       SG     76    220  22          2
    ## 282            Mario Hezonja  ORL       SF     80    215  21          1
    ## 283          Markieff Morris  WAS       PF     82    245  27          5
    ## 284          Marquese Chriss  PHO       PF     82    233  19          0
    ## 285        Marreese Speights  LAC        C     82    255  29          8
    ## 286         Marshall Plumlee  NYK        C     84    250  24          0
    ## 287          Marvin Williams  CHO       PF     81    237  30         11
    ## 288            Mason Plumlee  DEN        C     83    245  26          3
    ## 289              Matt Barnes  GSW       SF     79    226  36         13
    ## 290      Matthew Dellavedova  MIL       PG     76    198  26          3
    ## 291         Maurice Harkless  POR       SF     81    215  23          4
    ## 292            Maurice Ndour  NYK       PF     81    200  24          0
    ## 293        Metta World Peace  LAL       SF     78    260  37         16
    ## 294           Meyers Leonard  POR       PF     85    245  24          4
    ## 295          Michael Beasley  MIL       PF     81    235  28          8
    ## 296  Michael Carter-Williams  CHI       PG     78    190  25          3
    ## 297          Michael Gbinije  DET       SG     79    200  24          0
    ## 298   Michael Kidd-Gilchrist  CHO       SF     79    232  23          4
    ## 299              Mike Conley  MEM       PG     73    175  29          9
    ## 300            Mike Dunleavy  ATL       SF     81    230  36         14
    ## 301              Mike Miller  DEN       SF     80    218  36         16
    ## 302             Mike Muscala  ATL        C     83    240  25          3
    ## 303            Miles Plumlee  CHO        C     83    249  28          4
    ## 304     Mindaugas Kuzminskas  NYK       SF     81    215  27          0
    ## 305          Mirza Teletovic  MIL       PF     81    242  31          4
    ## 306              Monta Ellis  IND       SG     75    185  31         11
    ## 307         Montrezl Harrell  HOU        C     80    240  23          1
    ## 308             Myles Turner  IND        C     83    243  20          1
    ## 309          Nemanja Bjelica  MIN       PF     82    240  28          1
    ## 310             Nerlens Noel  DAL        C     83    228  22          2
    ## 311            Nick Collison  OKC       PF     82    255  36         12
    ## 312               Nick Young  LAL       SG     79    210  31          9
    ## 313            Nicolas Batum  CHO       SG     80    200  28          8
    ## 314         Nicolas Brussino  DAL       SF     79    195  23          0
    ## 315             Nik Stauskas  PHI       SG     78    205  23          2
    ## 316             Nikola Jokic  DEN        C     82    250  21          1
    ## 317           Nikola Mirotic  CHI       PF     82    220  25          2
    ## 318           Nikola Vucevic  ORL        C     84    260  26          5
    ## 319              Noah Vonleh  POR       PF     82    240  21          2
    ## 320            Norman Powell  TOR       SG     76    215  23          1
    ## 321              Norris Cole  OKC       PG     74    175  28          5
    ## 322              Okaro White  MIA       PF     80    204  24          0
    ## 323                Omer Asik  NOP        C     84    255  30          6
    ## 324              Omri Casspi  MIN       SF     81    225  28          7
    ## 325              Otto Porter  WAS       SF     80    198  23          3
    ## 326              P.J. Tucker  TOR       SF     78    245  31          5
    ## 327            Pascal Siakam  TOR       PF     81    230  22          0
    ## 328          Pat Connaughton  POR       SG     77    206  24          1
    ## 329          Patricio Garino  ORL       SG     78    210  23          0
    ## 330         Patrick Beverley  HOU       SG     73    185  28          4
    ## 331            Patrick McCaw  GSW       SG     79    185  21          0
    ## 332        Patrick Patterson  TOR       PF     81    230  27          6
    ## 333              Patty Mills  SAS       PG     72    185  28          7
    ## 334                Pau Gasol  SAS        C     84    250  36         15
    ## 335              Paul George  IND       SF     81    220  26          6
    ## 336             Paul Millsap  ATL       PF     80    246  31         10
    ## 337              Paul Pierce  LAC       SF     79    235  39         18
    ## 338              Paul Zipser  CHI       SF     80    215  22          0
    ## 339               Quincy Acy  BRK       PF     79    240  26          4
    ## 340               Quinn Cook  NOP       PG     74    184  23          0
    ## 341              Rajon Rondo  CHI       PG     73    186  30         10
    ## 342         Rakeem Christmas  IND       PF     81    250  25          1
    ## 343           Ramon Sessions  CHO       PG     75    190  30          9
    ## 344               Randy Foye  BRK       SG     76    213  33         10
    ## 345            Rashad Vaughn  MIL       SG     78    202  20          1
    ## 346                Raul Neto  UTA       PG     73    179  24          1
    ## 347           Raymond Felton  LAC       PG     73    205  32         11
    ## 348           Reggie Bullock  DET       SF     79    205  25          3
    ## 349           Reggie Jackson  DET       PG     75    208  26          5
    ## 350        Richard Jefferson  CLE       SF     79    233  36         15
    ## 351           Richaun Holmes  PHI        C     82    245  23          1
    ## 352              Ricky Rubio  MIN       PG     76    194  26          5
    ## 353         Robert Covington  PHI       SF     81    215  26          3
    ## 354              Robin Lopez  CHI        C     84    255  28          8
    ## 355              Rodney Hood  UTA       SG     80    206  24          2
    ## 356          Rodney McGruder  MIA       SG     76    205  25          0
    ## 357                Ron Baker  NYK       SG     76    220  23          0
    ## 358  Rondae Hollis-Jefferson  BRK       SF     79    220  22          1
    ## 359             Ronnie Price  PHO       PG     74    190  33         11
    ## 360              Roy Hibbert  DEN        C     86    270  30          8
    ## 361                 Rudy Gay  SAC       SF     80    230  30         10
    ## 362              Rudy Gobert  UTA        C     85    245  24          3
    ## 363        Russell Westbrook  OKC       PG     75    200  28          8
    ## 364            Ryan Anderson  HOU       PF     82    240  28          8
    ## 365               Ryan Kelly  ATL       PF     83    230  25          3
    ## 366              Salah Mejri  DAL        C     85    245  30          1
    ## 367               Sam Dekker  HOU       SF     81    230  22          1
    ## 368            Sasha Vujacic  NYK       SG     79    195  32          9
    ## 369          Sean Kilpatrick  BRK       SG     76    210  27          2
    ## 370           Semaj Christon  OKC       PG     75    190  24          0
    ## 371              Serge Ibaka  TOR       PF     82    235  27          7
    ## 372         Sergio Rodriguez  PHI       PG     75    176  30          4
    ## 373               Seth Curry  DAL       PG     74    185  26          3
    ## 374         Shabazz Muhammad  MIN       SF     78    223  24          3
    ## 375           Shabazz Napier  POR       PG     73    175  25          2
    ## 376         Shaun Livingston  GSW       PG     79    192  31         11
    ## 377               Shawn Long  PHI        C     81    255  24          0
    ## 378        Sheldon McClellan  WAS       SG     77    200  24          0
    ## 379             Shelvin Mack  UTA       PG     75    203  26          5
    ## 380          Skal Labissiere  SAC       PF     83    225  20          0
    ## 381             Solomon Hill  NOP       SF     79    225  25          3
    ## 382        Spencer Dinwiddie  BRK       PG     78    200  23          2
    ## 383            Spencer Hawes  MIL       PF     85    245  28          9
    ## 384          Stanley Johnson  DET       SF     79    245  20          1
    ## 385            Stephen Curry  GSW       PG     75    190  28          7
    ## 386        Stephen Zimmerman  ORL        C     84    240  20          0
    ## 387             Steven Adams  OKC        C     84    255  23          3
    ## 388           T.J. McConnell  PHI       PG     74    200  24          1
    ## 389              T.J. Warren  PHO       SF     80    230  23          2
    ## 390               Taj Gibson  OKC       PF     81    225  31          7
    ## 391              Tarik Black  LAL        C     81    250  25          2
    ## 392            Terrence Ross  ORL       SF     79    206  25          4
    ## 393             Terry Rozier  BOS       PG     74    190  22          1
    ## 394          Thabo Sefolosha  ATL       SF     79    220  32         10
    ## 395           Thaddeus Young  IND       PF     80    221  28          9
    ## 396          Thomas Robinson  LAL       PF     82    237  25          4
    ## 397               Thon Maker  MIL        C     85    216  19          0
    ## 398           Tiago Splitter  PHI        C     83    245  32          6
    ## 399              Tim Frazier  NOP       PG     73    170  26          2
    ## 400             Tim Hardaway  ATL       SG     78    205  24          3
    ## 401           Tim Quarterman  POR       SG     78    195  22          0
    ## 402           Timofey Mozgov  LAL        C     85    275  30          6
    ## 403  Timothe Luwawu-Cabarrot  PHI       SF     78    205  21          0
    ## 404            Tobias Harris  DET       PF     81    235  24          5
    ## 405         Tomas Satoransky  WAS       SG     79    210  25          0
    ## 406               Tony Allen  MEM       SG     76    213  35         12
    ## 407              Tony Parker  SAS       PG     74    185  34         15
    ## 408               Tony Snell  MIL       SG     79    200  25          3
    ## 409           Treveon Graham  CHO       SG     78    220  23          0
    ## 410             Trevor Ariza  HOU       SF     80    215  31         12
    ## 411            Trevor Booker  BRK       PF     80    228  29          6
    ## 412               Trey Burke  WAS       PG     73    191  24          3
    ## 413               Trey Lyles  UTA       PF     82    234  21          1
    ## 414         Tristan Thompson  CLE        C     81    238  25          5
    ## 415             Troy Daniels  MEM       SG     76    205  25          3
    ## 416            Troy Williams  HOU       SF     79    218  22          0
    ## 417                Ty Lawson  SAC       PG     71    195  29          7
    ## 418              Tyler Ennis  LAL       PG     75    194  22          2
    ## 419            Tyler Johnson  MIA       PG     76    186  24          2
    ## 420               Tyler Ulis  PHO       PG     70    150  21          0
    ## 421             Tyler Zeller  BOS        C     84    253  27          4
    ## 422             Tyreke Evans  SAC       SF     78    220  27          7
    ## 423           Tyson Chandler  PHO        C     85    240  34         15
    ## 424               Tyus Jones  MIN       PG     74    195  20          1
    ## 425            Udonis Haslem  MIA        C     80    235  36         13
    ## 426           Victor Oladipo  OKC       SG     76    210  24          3
    ## 427             Vince Carter  MEM       SF     78    220  40         18
    ## 428             Wade Baldwin  MEM       PG     76    202  20          0
    ## 429          Wayne Ellington  MIA       SG     76    200  29          7
    ## 430             Wayne Selden  MEM       SG     77    230  22          0
    ## 431           Wesley Johnson  LAC       SF     79    215  29          6
    ## 432          Wesley Matthews  DAL       SG     77    220  30          7
    ## 433              Will Barton  DEN       SG     78    175  26          4
    ## 434      Willie Cauley-Stein  SAC        C     84    240  23          1
    ## 435              Willie Reed  MIA        C     82    220  26          1
    ## 436        Willy Hernangomez  NYK        C     83    240  22          0
    ## 437          Wilson Chandler  DEN       SF     80    225  29          8
    ## 438             Yogi Ferrell  DAL       PG     72    180  23          0
    ## 439              Zach LaVine  MIN       SG     77    189  21          2
    ## 440            Zach Randolph  MEM       PF     81    260  35         15
    ## 441            Zaza Pachulia  GSW        C     83    270  32         13
    ##       salary
    ## 1     650000
    ## 2    2700000
    ## 3    4351320
    ## 4    2022240
    ## 5   26540100
    ## 6   10230179
    ## 7    7680965
    ## 8    1315448
    ## 9     874636
    ## 10  10154495
    ## 11   5994764
    ## 12   4823621
    ## 13     31969
    ## 14   4600000
    ## 15  18500000
    ## 16  12000000
    ## 17  22116750
    ## 18  11131368
    ## 19   2183072
    ## 20    945000
    ## 21   6088993
    ## 22   6006600
    ## 23  22116750
    ## 24   3488000
    ## 25   8000000
    ## 26    119494
    ## 27   6500000
    ## 28  12500000
    ## 29  11000000
    ## 30   8269663
    ## 31     20580
    ## 32   4008882
    ## 33   1551659
    ## 34  17000000
    ## 35  20140838
    ## 36   7000000
    ## 37    680534
    ## 38   1453680
    ## 39   3730653
    ## 40   7000000
    ## 41  22116750
    ## 42   5700000
    ## 43   1551659
    ## 44   5281680
    ## 45   1200000
    ## 46  12606250
    ## 47   3500000
    ## 48   1050961
    ## 49    102898
    ## 50   1273920
    ## 51  21165675
    ## 52   1589640
    ## 53    543471
    ## 54   3517200
    ## 55   3219579
    ## 56   4583450
    ## 57   5000000
    ## 58   2112480
    ## 59   1562280
    ## 60  24559380
    ## 61  22116750
    ## 62   7806971
    ## 63    143860
    ## 64    543471
    ## 65    543471
    ## 66   1191480
    ## 67  22868828
    ## 68    874636
    ## 69   1296240
    ## 70   5318313
    ## 71   7643979
    ## 72   7600000
    ## 73   7330000
    ## 74  11242000
    ## 75    874636
    ## 76   7250000
    ## 77   5332800
    ## 78     18255
    ## 79   1171560
    ## 80  24328425
    ## 81    980431
    ## 82    543471
    ## 83  15050000
    ## 84  10000000
    ## 85   2978250
    ## 86   3940320
    ## 87   2318280
    ## 88   8070175
    ## 89   5229454
    ## 90    874060
    ## 91   1551659
    ## 92     73528
    ## 93   1551659
    ## 94    543471
    ## 95  21165675
    ## 96   1015696
    ## 97   1499760
    ## 98   1180080
    ## 99   1577280
    ## 100 26540100
    ## 101 16957900
    ## 102 14200000
    ## 103  1450000
    ## 104  2708582
    ## 105  2092200
    ## 106   259626
    ## 107 11050000
    ## 108   543471
    ## 109 21323250
    ## 110   268029
    ## 111  2223600
    ## 112  4228000
    ## 113  2898000
    ## 114  1369229
    ## 115   543471
    ## 116  2898000
    ## 117 25000000
    ## 118  2440200
    ## 119   576724
    ## 120   543471
    ## 121  2483040
    ## 122  4276320
    ## 123 15330435
    ## 124 23180275
    ## 125  8375000
    ## 126 23200000
    ## 127  8081363
    ## 128  6666667
    ## 129     5145
    ## 130  2613600
    ## 131    23069
    ## 132  3241800
    ## 133 17145838
    ## 134 14000000
    ## 135 12385364
    ## 136  8400000
    ## 137 17000000
    ## 138 16393443
    ## 139  2730000
    ## 140   543471
    ## 141  8000000
    ## 142  1655880
    ## 143  8000000
    ## 144   650000
    ## 145  2202240
    ## 146  1410598
    ## 147  9000000
    ## 148  2995421
    ## 149 15890000
    ## 150 16073140
    ## 151  2348783
    ## 152 17100000
    ## 153 22116750
    ## 154 22116750
    ## 155  1704120
    ## 156  1015696
    ## 157 15944154
    ## 158  9700000
    ## 159  1015696
    ## 160   255000
    ## 161  6587132
    ## 162  1074145
    ## 163  6000000
    ## 164  1034956
    ## 165  4096950
    ## 166  7377500
    ## 167 12800000
    ## 168  5374320
    ## 169  6286408
    ## 170  4788840
    ## 171   600000
    ## 172  2703960
    ## 173 13253012
    ## 174  3210840
    ## 175  4540525
    ## 176  2898000
    ## 177 26540100
    ## 178  4000000
    ## 179  1551659
    ## 180   980431
    ## 181  1825200
    ## 182   980431
    ## 183 10470000
    ## 184  1286160
    ## 185    63938
    ## 186  5000000
    ## 187  1551659
    ## 188  1403611
    ## 189  4743000
    ## 190 15000000
    ## 191  8800000
    ## 192  1015696
    ## 193   980431
    ## 194  6511628
    ## 195 11483254
    ## 196  1643040
    ## 197  9424084
    ## 198 17552209
    ## 199 17000000
    ## 200  6540000
    ## 201   980431
    ## 202  2250000
    ## 203 11000000
    ## 204  1052342
    ## 205   165952
    ## 206   600000
    ## 207  4826160
    ## 208  1709720
    ## 209 12517606
    ## 210 16957900
    ## 211   161483
    ## 212 10991957
    ## 213  5000000
    ## 214 14382022
    ## 215   874636
    ## 216 12500000
    ## 217   173094
    ## 218  3911380
    ## 219  1223653
    ## 220   392478
    ## 221  1191480
    ## 222  5782450
    ## 223   874636
    ## 224 11286518
    ## 225  1987440
    ## 226  3267120
    ## 227  1514160
    ## 228  3000000
    ## 229  1015696
    ## 230  2593440
    ## 231  1921320
    ## 232  3333333
    ## 233  5960160
    ## 234 17638063
    ## 235   543471
    ## 236  3094014
    ## 237 12000000
    ## 238 12078652
    ## 239 15730338
    ## 240  3678319
    ## 241 26540100
    ## 242 21165675
    ## 243  1800000
    ## 244  1182840
    ## 245 15200000
    ## 246 16663575
    ## 247  8046500
    ## 248  3872520
    ## 249  4000000
    ## 250  4317720
    ## 251  1192080
    ## 252  5239437
    ## 253 12000000
    ## 254  3900000
    ## 255  4837500
    ## 256   543471
    ## 257 17638063
    ## 258 20575005
    ## 259  4000000
    ## 260  6191000
    ## 261  5200000
    ## 262  1207680
    ## 263  4000000
    ## 264  4000000
    ## 265 30963450
    ## 266  7000000
    ## 267  2203000
    ## 268  1921320
    ## 269  1227000
    ## 270 18000000
    ## 271  1439880
    ## 272   925000
    ## 273  2500000
    ## 274  1627320
    ## 275 14000000
    ## 276 21165675
    ## 277 12000000
    ## 278  6333333
    ## 279    31969
    ## 280  4625000
    ## 281  3578880
    ## 282  3909840
    ## 283  7400000
    ## 284  2941440
    ## 285  1403611
    ## 286   543471
    ## 287 12250000
    ## 288  2328530
    ## 289   383351
    ## 290  9607500
    ## 291  8988764
    ## 292   543471
    ## 293  1551659
    ## 294  9213484
    ## 295  1403611
    ## 296  3183526
    ## 297   650000
    ## 298 13000000
    ## 299 26540100
    ## 300  4837500
    ## 301  3500000
    ## 302  1015696
    ## 303 12500000
    ## 304  2898000
    ## 305 10500000
    ## 306 10770000
    ## 307  1000000
    ## 308  2463840
    ## 309  3800000
    ## 310  4384490
    ## 311  3750000
    ## 312  5443918
    ## 313 20869566
    ## 314   543471
    ## 315  2993040
    ## 316  1358500
    ## 317  5782450
    ## 318 11750000
    ## 319  2751360
    ## 320   874636
    ## 321   247991
    ## 322   210995
    ## 323  9904494
    ## 324   138414
    ## 325  5893981
    ## 326  5300000
    ## 327  1196040
    ## 328   874636
    ## 329    31969
    ## 330  6000000
    ## 331   543471
    ## 332  6050000
    ## 333  3578948
    ## 334 15500000
    ## 335 18314532
    ## 336 20072033
    ## 337  3500000
    ## 338   750000
    ## 339  1790902
    ## 340    63938
    ## 341 14000000
    ## 342  1052342
    ## 343  6000000
    ## 344  2500000
    ## 345  1811040
    ## 346   937800
    ## 347  1551659
    ## 348  2255644
    ## 349 14956522
    ## 350  2500000
    ## 351  1025831
    ## 352 13550000
    ## 353  1015696
    ## 354 13219250
    ## 355  1406520
    ## 356   543471
    ## 357   543471
    ## 358  1395600
    ## 359   282595
    ## 360  5000000
    ## 361 13333333
    ## 362  2121288
    ## 363 26540100
    ## 364 18735364
    ## 365   418228
    ## 366   874636
    ## 367  1720560
    ## 368  1410598
    ## 369   980431
    ## 370   543471
    ## 371 12250000
    ## 372  8000000
    ## 373  2898000
    ## 374  3046299
    ## 375  1350120
    ## 376  5782450
    ## 377    89513
    ## 378   543471
    ## 379  2433334
    ## 380  1188840
    ## 381 11241218
    ## 382   726672
    ## 383  6348759
    ## 384  2969880
    ## 385 12112359
    ## 386   950000
    ## 387  3140517
    ## 388   874636
    ## 389  2128920
    ## 390  8950000
    ## 391  6191000
    ## 392 10000000
    ## 393  1906440
    ## 394  3850000
    ## 395 14153652
    ## 396  1050961
    ## 397  2568600
    ## 398  8550000
    ## 399  2090000
    ## 400  2281605
    ## 401   543471
    ## 402 16000000
    ## 403  1326960
    ## 404 17200000
    ## 405  2870813
    ## 406  5505618
    ## 407 14445313
    ## 408  2368327
    ## 409   543471
    ## 410  7806971
    ## 411  9250000
    ## 412  3386598
    ## 413  2340600
    ## 414 15330435
    ## 415  3332940
    ## 416   150000
    ## 417  1315448
    ## 418  1733880
    ## 419  5628000
    ## 420   918369
    ## 421  8000000
    ## 422 10661286
    ## 423 12415000
    ## 424  1339680
    ## 425  4000000
    ## 426  6552960
    ## 427  4264057
    ## 428  1793760
    ## 429  6000000
    ## 430    83119
    ## 431  5628000
    ## 432 17100000
    ## 433  3533333
    ## 434  3551160
    ## 435  1015696
    ## 436  1375000
    ## 437 11200000
    ## 438   207798
    ## 439  2240880
    ## 440 10361445
    ## 441  2898000

Ex 4: Unique notation where one can select various columns from the multiple data\_frames based on the a similarity in the the columns. For this example we are compiling important information around the name of the player.

``` r
dat_stats2 <- sqldf("SELECT a.player, a.points, a.assists, b.position, b.age, b.experience, b.salary, b.team
                    FROM dat_stats as a, dat1 as b
                    WHERE a.player = b.player
                   ")
dat_stats2
```

    ##                       player points assists position age experience
    ## 1                 Al Horford    952     337        C  30          9
    ## 2               Amir Johnson    520     140       PF  29         11
    ## 3              Avery Bradley    894     121       SG  26          6
    ## 4          Demetrius Jackson     10       3       PG  22          0
    ## 5               Gerald Green    262      33       SF  31          9
    ## 6              Isaiah Thomas   2199     449       PG  27          5
    ## 7                Jae Crowder    999     155       SF  26          4
    ## 8                James Young     68       4       SG  21          2
    ## 9               Jaylen Brown    515      64       SF  20          0
    ## 10             Jonas Jerebko    299      71       PF  29          6
    ## 11             Jordan Mickey     38       7       PF  22          1
    ## 12              Kelly Olynyk    678     148        C  25          3
    ## 13              Marcus Smart    835     364       SG  22          2
    ## 14              Terry Rozier    410     131       PG  22          1
    ## 15              Tyler Zeller    178      42        C  27          4
    ## 16             Channing Frye    676      45        C  33         10
    ## 17             Dahntay Jones      9       1       SF  36         12
    ## 18            Deron Williams    179      86       PG  32         11
    ## 19          Derrick Williams    156      14       PF  25          5
    ## 20               Edy Tavares      6       1        C  24          1
    ## 21             Iman Shumpert    567     109       SG  26          5
    ## 22                J.R. Smith    351      62       SG  31         12
    ## 23               James Jones    132      14       SF  36         13
    ## 24                Kay Felder    166      58       PG  21          0
    ## 25                Kevin Love   1142     116       PF  28          8
    ## 26               Kyle Korver    373      35       SG  35         13
    ## 27              Kyrie Irving   1816     418       PG  24          5
    ## 28              LeBron James   1954     646       SF  32         13
    ## 29         Richard Jefferson    448      78       SF  36         15
    ## 30          Tristan Thompson    630      77        C  25          5
    ## 31             Bruno Caboclo     14       4       SF  21          2
    ## 32               Cory Joseph    740     265       SG  25          5
    ## 33              Delon Wright    150      57       PG  24          1
    ## 34             DeMar DeRozan   2020     290       SG  27          7
    ## 35           DeMarre Carroll    638      74       SF  30          7
    ## 36             Fred VanVleet    107      35       PG  22          0
    ## 37              Jakob Poeltl    165      12        C  21          0
    ## 38         Jonas Valanciunas    959      57        C  24          4
    ## 39                Kyle Lowry   1344     417       PG  30         10
    ## 40            Lucas Nogueira    253      42        C  24          2
    ## 41             Norman Powell    636      82       SG  23          1
    ## 42               P.J. Tucker    139      26       SF  31          5
    ## 43             Pascal Siakam    229      17       PF  22          0
    ## 44         Patrick Patterson    445      76       PF  27          6
    ## 45               Serge Ibaka    327      15       PF  27          7
    ## 46          Bojan Bogdanovic    330      21       SF  27          2
    ## 47              Bradley Beal   1779     267       SG  23          4
    ## 48          Brandon Jennings     81     108       PG  27          7
    ## 49          Chris McCullough      1       0       PF  21          1
    ## 50             Daniel Ochefu     24       3        C  23          0
    ## 51               Ian Mahinmi    173      19        C  30          8
    ## 52               Jason Smith    420      37        C  30          8
    ## 53                 John Wall   1805     831       PG  26          6
    ## 54             Marcin Gortat    883     121        C  32          9
    ## 55           Markieff Morris   1063     126       PF  27          5
    ## 56               Otto Porter   1075     121       SF  23          3
    ## 57         Sheldon McClellan     90      15       SG  24          0
    ## 58          Tomas Satoransky    154      92       SG  25          0
    ## 59                Trey Burke    285     100       PG  24          3
    ## 60           DeAndre' Bembry    101      28       SF  22          0
    ## 61           Dennis Schroder   1414     499       PG  23          3
    ## 62             Dwight Howard   1002     104        C  31         12
    ## 63            Ersan Ilyasova    270      43       PF  29          8
    ## 64             Jose Calderon     61      37       PG  35         11
    ## 65             Kent Bazemore    801     177       SF  27          4
    ## 66            Kris Humphries    257      29       PF  31         12
    ## 67           Malcolm Delaney    391     193       PG  27          0
    ## 68             Mike Dunleavy    169      30       SF  36         14
    ## 69              Mike Muscala    435      95        C  25          3
    ## 70              Paul Millsap   1246     252       PF  31         10
    ## 71                Ryan Kelly     25       8       PF  25          3
    ## 72           Thabo Sefolosha    444     107       SF  32         10
    ## 73              Tim Hardaway   1143     182       SG  24          3
    ## 74     Giannis Antetokounmpo   1832     434       SF  22          3
    ## 75               Greg Monroe    951     187        C  26          6
    ## 76             Jabari Parker   1025     142       PF  21          2
    ## 77               Jason Terry    307      98       SG  39         17
    ## 78               John Henson    392      57        C  26          4
    ## 79           Khris Middleton    426      99       SF  25          4
    ## 80           Malcolm Brogdon    767     317       SG  24          0
    ## 81       Matthew Dellavedova    577     357       PG  26          3
    ## 82           Michael Beasley    528      53       PF  28          8
    ## 83           Mirza Teletovic    451      48       PF  31          4
    ## 84             Rashad Vaughn    142      23       SG  20          1
    ## 85             Spencer Hawes     83      19       PF  28          9
    ## 86                Thon Maker    226      23        C  19          0
    ## 87                Tony Snell    683      96       SG  25          3
    ## 88              Aaron Brooks    322     125       PG  32          8
    ## 89              Al Jefferson    535      57        C  32         12
    ## 90                C.J. Miles    815      48       SF  29         11
    ## 91             Georges Niang     21       5       PF  23          0
    ## 92               Jeff Teague   1254     639       PG  28          7
    ## 93                 Joe Young     68      15       PG  24          1
    ## 94            Kevin Seraphin    232      23       PF  27          6
    ## 95          Lance Stephenson     43      25       SG  26          6
    ## 96               Lavoy Allen    177      57       PF  27          5
    ## 97               Monta Ellis    630     236       SG  31         11
    ## 98              Myles Turner   1173     106        C  20          1
    ## 99               Paul George   1775     251       SF  26          6
    ## 100         Rakeem Christmas     59       4       PF  25          1
    ## 101           Thaddeus Young    814     122       PF  28          9
    ## 102           Anthony Morrow     41       6       SG  31          8
    ## 103             Bobby Portis    437      35       PF  21          1
    ## 104            Cameron Payne     54      15       PG  22          1
    ## 105        Cristiano Felicio    316      40        C  24          1
    ## 106         Denzel Valentine    291      63       SG  23          0
    ## 107              Dwyane Wade   1096     229       SG  35         13
    ## 108            Isaiah Canaan    181      37       SG  25          3
    ## 109             Jerian Grant    370     120       PG  24          1
    ## 110             Jimmy Butler   1816     417       SF  27          5
    ## 111        Joffrey Lauvergne     89      19        C  25          2
    ## 112  Michael Carter-Williams    297     113       PG  25          3
    ## 113           Nikola Mirotic    744      75       PF  25          2
    ## 114              Paul Zipser    240      36       SF  22          0
    ## 115              Rajon Rondo    538     461       PG  30         10
    ## 116              Robin Lopez    839      80        C  28          8
    ## 117             Dion Waiters    729     200       SG  25          4
    ## 118             Goran Dragic   1483     423       PG  30          8
    ## 119         Hassan Whiteside   1309      57        C  27          4
    ## 120            James Johnson    975     276       PF  29          7
    ## 121           Josh McRoberts    107      50       PF  29          9
    ## 122          Josh Richardson    539     140       SG  23          1
    ## 123          Justise Winslow    196      66       SF  20          1
    ## 124             Luke Babbitt    324      36       SF  27          6
    ## 125              Okaro White     98      21       PF  24          0
    ## 126          Rodney McGruder    497     124       SG  25          0
    ## 127            Tyler Johnson   1002     233       PG  24          2
    ## 128            Udonis Haslem     31       6        C  36         13
    ## 129          Wayne Ellington    648      70       SG  29          7
    ## 130              Willie Reed    374      26        C  26          1
    ## 131           Andre Drummond   1105      89        C  23          4
    ## 132              Aron Baynes    365      32        C  30          4
    ## 133               Beno Udrih    227     131       PG  34         12
    ## 134         Boban Marjanovic    191       9        C  28          1
    ## 135          Darrun Hilliard    127      33       SG  23          1
    ## 136           Henry Ellenson     60       7       PF  20          0
    ## 137                Ish Smith    758     418       PG  28          6
    ## 138                Jon Leuer    767     111       PF  27          5
    ## 139 Kentavious Caldwell-Pope   1047     193       SG  23          3
    ## 140            Marcus Morris   1105     160       SF  27          5
    ## 141          Michael Gbinije      4       2       SG  24          0
    ## 142           Reggie Bullock    141      29       SF  25          3
    ## 143           Reggie Jackson    752     270       PG  26          5
    ## 144          Stanley Johnson    339     105       SF  20          1
    ## 145            Tobias Harris   1321     142       PF  24          5
    ## 146            Brian Roberts    142      52       PG  31          4
    ## 147            Briante Weber     50      16       PG  24          1
    ## 148           Christian Wood     35       2       PF  21          1
    ## 149              Cody Zeller    639      99       PF  24          3
    ## 150           Frank Kaminsky    874     162        C  23          1
    ## 151              Jeremy Lamb    603      75       SG  24          4
    ## 152          Johnny O'Bryant     18       4       PF  23          2
    ## 153             Kemba Walker   1830     435       PG  26          5
    ## 154          Marco Belinelli    780     147       SG  30          9
    ## 155          Marvin Williams    849     106       PF  30         11
    ## 156   Michael Kidd-Gilchrist    743     114       SF  23          4
    ## 157            Miles Plumlee     31       3        C  28          4
    ## 158            Nicolas Batum   1164     455       SG  28          8
    ## 159           Ramon Sessions    312     129       PG  30          9
    ## 160           Treveon Graham     57       6       SG  23          0
    ## 161          Carmelo Anthony   1659     213       SF  32         13
    ## 162           Chasson Randle     95      28       PG  23          0
    ## 163             Courtney Lee    835     179       SG  31          8
    ## 164             Derrick Rose   1154     283       PG  28          7
    ## 165              Joakim Noah    232     103        C  31          9
    ## 166           Justin Holiday    629     102       SG  27          3
    ## 167       Kristaps Porzingis   1196      97       PF  21          1
    ## 168             Kyle O'Quinn    496     117        C  26          4
    ## 169             Lance Thomas    275      35       PF  28          5
    ## 170         Marshall Plumlee     40      10        C  24          0
    ## 171            Maurice Ndour     98       8       PF  24          0
    ## 172     Mindaugas Kuzminskas    425      69       SF  27          0
    ## 173                Ron Baker    215     107       SG  23          0
    ## 174            Sasha Vujacic    124      52       SG  32          9
    ## 175        Willy Hernangomez    587      96        C  22          0
    ## 176             Aaron Gordon   1019     150       SF  21          2
    ## 177          Bismack Biyombo    483      74        C  24          5
    ## 178              C.J. Watson    281     114       PG  32          9
    ## 179            D.J. Augustin    616     209       PG  29          8
    ## 180             Damjan Rudez     82      20       SF  30          2
    ## 181            Elfrid Payton   1046     529       PG  22          2
    ## 182            Evan Fournier   1167     202       SG  24          4
    ## 183               Jeff Green    638      81       PF  30          8
    ## 184              Jodie Meeks    327      45       SG  29          7
    ## 185      Marcus Georges-Hunt     14       3       SG  22          0
    ## 186            Mario Hezonja    317      62       SF  21          1
    ## 187           Nikola Vucevic   1096     208        C  26          5
    ## 188          Patricio Garino      0       0       SG  23          0
    ## 189        Stephen Zimmerman     23       4        C  20          0
    ## 190            Terrence Ross    299      43       SF  25          4
    ## 191           Alex Poythress     64       5       PF  23          0
    ## 192              Dario Saric   1040     182       PF  22          0
    ## 193         Gerald Henderson    662     112       SG  29          7
    ## 194            Jahlil Okafor    590      58        C  21          1
    ## 195           Jerryd Bayless     33      13       PG  28          8
    ## 196              Joel Embiid    627      66        C  22          0
    ## 197          Justin Anderson    203      34       SF  23          1
    ## 198             Nik Stauskas    756     188       SG  23          2
    ## 199           Richaun Holmes    559      58        C  23          1
    ## 200         Robert Covington    864     102       SF  26          3
    ## 201         Sergio Rodriguez    530     344       PG  30          4
    ## 202               Shawn Long    148      13        C  24          0
    ## 203           T.J. McConnell    556     534       PG  24          1
    ## 204           Tiago Splitter     39       4        C  32          6
    ## 205  Timothe Luwawu-Cabarrot    445      75       SF  21          0
    ## 206         Andrew Nicholson     30       3       PF  27          4
    ## 207           Archie Goodwin     95      23       SG  22          3
    ## 208              Brook Lopez   1539     176        C  28          8
    ## 209             Caris LeVert    468     110       SF  22          0
    ## 210         Isaiah Whitehead    543     192       PG  21          0
    ## 211               Jeremy Lin    523     184       PG  28          6
    ## 212               Joe Harris    428      54       SG  25          2
    ## 213          Justin Hamilton    442      55        C  26          2
    ## 214           K.J. McDaniels    126       9       SF  23          2
    ## 215               Quincy Acy    209      18       PF  26          4
    ## 216               Randy Foye    357     135       SG  33         10
    ## 217  Rondae Hollis-Jefferson    675     154       SF  22          1
    ## 218          Sean Kilpatrick    919     157       SG  27          2
    ## 219        Spencer Dinwiddie    432     185       PG  23          2
    ## 220            Trevor Booker    709     138       PF  29          6
    ## 221           Andre Iguodala    574     262       SF  33         12
    ## 222             Damian Jones     19       0        C  21          0
    ## 223               David West    316     151        C  36         13
    ## 224           Draymond Green    776     533       PF  26          4
    ## 225                Ian Clark    527      90       SG  25          3
    ## 226     James Michael McAdoo    147      17       PF  24          2
    ## 227             JaVale McGee    472      17        C  29          8
    ## 228             Kevin Durant   1555     300       SF  28          9
    ## 229             Kevon Looney    135      29        C  20          1
    ## 230            Klay Thompson   1742     160       SG  26          5
    ## 231              Matt Barnes    114      45       SF  36         13
    ## 232            Patrick McCaw    282      77       SG  21          0
    ## 233         Shaun Livingston    389     139       PG  31         11
    ## 234            Stephen Curry   1999     523       PG  28          7
    ## 235            Zaza Pachulia    426     132        C  32         13
    ## 236              Bryn Forbes     94      23       SG  23          0
    ## 237              Danny Green    497     124       SG  29          7
    ## 238                David Lee    576     124       PF  33         11
    ## 239            Davis Bertans    303      46       PF  24          0
    ## 240          Dejounte Murray    130      48       PG  20          0
    ## 241           Dewayne Dedmon    387      44        C  27          3
    ## 242             Joel Anthony     25       3        C  34          9
    ## 243         Jonathon Simmons    483     126       SG  27          1
    ## 244            Kawhi Leonard   1888     260       SF  25          5
    ## 245            Kyle Anderson    246      91       SG  23          2
    ## 246        LaMarcus Aldridge   1243     139       PF  31         10
    ## 247            Manu Ginobili    517     183       SG  39         14
    ## 248              Patty Mills    759     280       PG  28          7
    ## 249                Pau Gasol    792     150        C  36         15
    ## 250              Tony Parker    638     285       PG  34         15
    ## 251              Bobby Brown     62      14       PG  32          2
    ## 252           Chinanu Onuaku     14       3        C  20          0
    ## 253             Clint Capela    818      64        C  22          2
    ## 254              Eric Gordon   1217     188       SG  28          8
    ## 255            Isaiah Taylor      3       3       PG  22          0
    ## 256             James Harden   2356     906       PG  27          7
    ## 257             Kyle Wiltjer     13       2       PF  24          0
    ## 258             Lou Williams    343      56       SG  30         11
    ## 259         Montrezl Harrell    527      64        C  23          1
    ## 260         Patrick Beverley    639     281       SG  28          4
    ## 261            Ryan Anderson    979      68       PF  28          8
    ## 262               Sam Dekker    504      76       SF  22          1
    ## 263             Trevor Ariza    936     175       SF  31         12
    ## 264            Troy Williams     58       6       SF  22          0
    ## 265            Alan Anderson     86      11       SF  34          7
    ## 266            Austin Rivers    889     204       SG  24          4
    ## 267            Blake Griffin   1316     300       PF  27          6
    ## 268             Brandon Bass    292      21       PF  31         11
    ## 269            Brice Johnson      4       1       PF  22          0
    ## 270               Chris Paul   1104     563       PG  31         11
    ## 271           DeAndre Jordan   1029      96        C  28          8
    ## 272            Diamond Stone     10       0        C  19          0
    ## 273              J.J. Redick   1173     110       SG  32         10
    ## 274           Jamal Crawford   1008     213       SG  36         16
    ## 275         Luc Mbah a Moute    484      39       SF  30          8
    ## 276        Marreese Speights    711      66        C  29          8
    ## 277              Paul Pierce     81      10       SF  39         18
    ## 278           Raymond Felton    538     191       PG  32         11
    ## 279           Wesley Johnson    186      23       SF  29          6
    ## 280               Alec Burks    283      30       SG  25          5
    ## 281               Boris Diaw    338     170       PF  34         13
    ## 282               Dante Exum    412     112       PG  21          1
    ## 283           Derrick Favors    476      56       PF  25          6
    ## 284              George Hill    829     203       PG  30          8
    ## 285           Gordon Hayward   1601     252       SF  26          6
    ## 286              Jeff Withey    146       7        C  26          3
    ## 287               Joe Ingles    581     224       SF  29          2
    ## 288              Joe Johnson    715     144       SF  35         15
    ## 289            Joel Bolomboy     22       2       PF  23          0
    ## 290                Raul Neto    100      34       PG  24          1
    ## 291              Rodney Hood    748      96       SG  24          2
    ## 292              Rudy Gobert   1137      97        C  24          3
    ## 293             Shelvin Mack    430     154       PG  26          5
    ## 294               Trey Lyles    440      70       PF  21          1
    ## 295             Alex Abrines    406      40       SG  23          0
    ## 296           Andre Roberson    522      79       SF  25          3
    ## 297         Domantas Sabonis    479      82       PF  20          0
    ## 298           Doug McDermott    145      13       SF  25          2
    ## 299              Enes Kanter   1033      67        C  24          5
    ## 300             Jerami Grant    421      46       SF  22          2
    ## 301             Josh Huestis     14       3       PF  25          1
    ## 302             Kyle Singler     88       9       SF  28          4
    ## 303            Nick Collison     33      12       PF  36         12
    ## 304              Norris Cole     43      14       PG  28          5
    ## 305        Russell Westbrook   2558     840       PG  28          8
    ## 306           Semaj Christon    183     130       PG  24          0
    ## 307             Steven Adams    905      86        C  23          3
    ## 308               Taj Gibson    207      13       PF  31          7
    ## 309           Victor Oladipo   1067     176       SG  24          3
    ## 310          Andrew Harrison    425     198       PG  22          0
    ## 311           Brandan Wright    189      15       PF  29          8
    ## 312         Chandler Parsons    210      55       SF  28          5
    ## 313            Deyonta Davis     58       2        C  20          0
    ## 314              James Ennis    429      64       SF  26          2
    ## 315           JaMychal Green    689      84       PF  26          2
    ## 316            Jarell Martin    165       8       PF  22          1
    ## 317               Marc Gasol   1446     338        C  32          8
    ## 318              Mike Conley   1415     433       PG  29          9
    ## 319               Tony Allen    643      98       SG  35         12
    ## 320             Troy Daniels    551      46       SG  25          3
    ## 321             Vince Carter    586     133       SF  40         18
    ## 322             Wade Baldwin    106      61       PG  20          0
    ## 323             Wayne Selden     55      12       SG  22          0
    ## 324            Zach Randolph   1028     122       PF  35         15
    ## 325          Al-Farouq Aminu    532      99       SF  26          6
    ## 326             Allen Crabbe    845      93       SG  24          3
    ## 327            C.J. McCollum   1837     285       SG  25          3
    ## 328           Damian Lillard   2024     439       PG  26          4
    ## 329                 Ed Davis    200      27       PF  27          6
    ## 330              Evan Turner    586     205       SF  28          6
    ## 331              Jake Layman     78      11       SF  22          0
    ## 332             Jusuf Nurkic    304      63        C  22          2
    ## 333         Maurice Harkless    773      89       SF  23          4
    ## 334           Meyers Leonard    401      71       PF  24          4
    ## 335              Noah Vonleh    327      31       PF  21          2
    ## 336          Pat Connaughton     98      28       SG  24          1
    ## 337           Shabazz Napier    218      67       PG  25          2
    ## 338           Tim Quarterman     31      11       SG  22          0
    ## 339         Danilo Gallinari   1145     136       SF  28          7
    ## 340           Darrell Arthur    262      42       PF  28          7
    ## 341          Emmanuel Mudiay    603     217       PG  20          1
    ## 342              Gary Harris    851     164       SG  22          2
    ## 343             Jamal Murray    811     170       SG  19          0
    ## 344            Jameer Nelson    687     385       PG  34         12
    ## 345         Juan Hernangomez    305      29       PF  21          0
    ## 346           Kenneth Faried    587      55       PF  27          5
    ## 347            Malik Beasley     83      11       SG  20          0
    ## 348            Mason Plumlee    245      70        C  26          3
    ## 349              Mike Miller     28      22       SF  36         16
    ## 350             Nikola Jokic   1221     358        C  21          1
    ## 351              Roy Hibbert      4       1        C  30          8
    ## 352              Will Barton    820     206       SG  26          4
    ## 353          Wilson Chandler   1117     143       SF  29          8
    ## 354            Alexis Ajinca    207      12        C  28          6
    ## 355            Anthony Davis   2099     157        C  23          4
    ## 356             Axel Toupane     11       0       SF  24          1
    ## 357            Cheick Diallo     87       4       PF  20          0
    ## 358         Dante Cunningham    435      36       SF  29          7
    ## 359         DeMarcus Cousins    414      66        C  26          6
    ## 360       Donatas Motiejunas    150      34       PF  26          4
    ## 361            E'Twaun Moore    700     164       SG  27          5
    ## 362          Jordan Crawford    267      57       SG  28          4
    ## 363             Jrue Holiday   1029     488       PG  26          7
    ## 364                Omer Asik     85      15        C  30          6
    ## 365               Quinn Cook     52      14       PG  23          0
    ## 366             Solomon Hill    563     141       SF  25          3
    ## 367              Tim Frazier    464     335       PG  26          2
    ## 368             A.J. Hammons     48       4        C  24          0
    ## 369          DeAndre Liggins      8       0       SG  28          3
    ## 370             Devin Harris    437     136       PG  33         12
    ## 371            Dirk Nowitzki    769      82       PF  38         18
    ## 372      Dorian Finney-Smith    350      67       PF  23          0
    ## 373            Dwight Powell    516      49        C  25          2
    ## 374          Harrison Barnes   1518     117       PF  24          4
    ## 375               J.J. Barea    381     193       PG  32         10
    ## 376            Jarrod Uthoff     40       9       PF  23          0
    ## 377             Nerlens Noel    188      20        C  22          2
    ## 378         Nicolas Brussino    150      47       SF  23          0
    ## 379              Salah Mejri    213      14        C  30          1
    ## 380               Seth Curry    898     188       PG  26          3
    ## 381          Wesley Matthews    986     210       SG  30          7
    ## 382             Yogi Ferrell    408     155       PG  23          0
    ## 383         Anthony Tolliver    461      77       PF  31          8
    ## 384            Arron Afflalo    515      78       SG  31          9
    ## 385             Ben McLemore    495      51       SG  23          3
    ## 386              Buddy Hield    378      44       SG  23          0
    ## 387          Darren Collison    900     312       PG  29          7
    ## 388           Garrett Temple    506     169       SG  30          6
    ## 389     Georgios Papagiannis    124      20        C  19          0
    ## 390             Kosta Koufos    470      47        C  27          8
    ## 391        Langston Galloway    114      28       PG  25          2
    ## 392       Malachi Richardson     79      11       SG  21          0
    ## 393                 Rudy Gay    562      82       SF  30         10
    ## 394          Skal Labissiere    289      27       PF  20          0
    ## 395                Ty Lawson    681     335       PG  29          7
    ## 396             Tyreke Evans    163      33       SF  27          7
    ## 397      Willie Cauley-Stein    611      80        C  23          1
    ## 398            Adreian Payne     63       7       PF  25          2
    ## 399           Andrew Wiggins   1933     189       SF  21          2
    ## 400             Brandon Rush    197      45       SG  31          8
    ## 401             Cole Aldrich    105      25        C  28          6
    ## 402             Gorgui Dieng    816     158       PF  27          3
    ## 403              Jordan Hill     12       0        C  29          7
    ## 404       Karl-Anthony Towns   2061     220        C  21          1
    ## 405                Kris Dunn    293     188       PG  22          0
    ## 406          Nemanja Bjelica    403      79       PF  28          1
    ## 407              Omri Casspi     45      11       SF  28          7
    ## 408              Ricky Rubio    836     682       PG  26          5
    ## 409         Shabazz Muhammad    772      35       SF  24          3
    ## 410               Tyus Jones    209     156       PG  20          1
    ## 411              Zach LaVine    889     139       SG  21          2
    ## 412           Brandon Ingram    740     166       SF  19          0
    ## 413             Corey Brewer    129      36       SF  30          9
    ## 414         D'Angelo Russell    984     303       PG  20          1
    ## 415              David Nwaba    120      14       SG  24          0
    ## 416              Ivica Zubac    284      30        C  19          0
    ## 417          Jordan Clarkson   1205     213       SG  24          2
    ## 418            Julius Randle    975     264       PF  22          2
    ## 419          Larry Nance Jr.    449      96       PF  24          1
    ## 420                Luol Deng    425      74       SF  31         12
    ## 421        Metta World Peace     57      11       SF  37         16
    ## 422               Nick Young    791      58       SG  31          9
    ## 423              Tarik Black    383      39        C  25          2
    ## 424          Thomas Robinson    241      31       PF  25          4
    ## 425           Timofey Mozgov    401      43        C  30          6
    ## 426              Tyler Ennis    170      52       PG  22          2
    ## 427            Alan Williams    346      23        C  24          1
    ## 428                 Alex Len    613      44        C  23          3
    ## 429           Brandon Knight    595     130       SG  25          5
    ## 430            Derrick Jones    168      12       SF  19          0
    ## 431             Devin Booker   1726     268       SG  20          1
    ## 432            Dragan Bender    146      23       PF  19          0
    ## 433           Elijah Millsap      3       1       SG  29          2
    ## 434             Eric Bledsoe   1390     418       PG  27          6
    ## 435             Jared Dudley    434     121       PF  31          9
    ## 436          Leandro Barbosa    419      81       SG  34         13
    ## 437          Marquese Chriss    753      60       PF  19          0
    ## 438             Ronnie Price     14      18       PG  33         11
    ## 439              T.J. Warren    951      75       SF  23          2
    ## 440               Tyler Ulis    444     226       PG  21          0
    ## 441           Tyson Chandler    397      30        C  34         15
    ##       salary team
    ## 1   26540100  BOS
    ## 2   12000000  BOS
    ## 3    8269663  BOS
    ## 4    1450000  BOS
    ## 5    1410598  BOS
    ## 6    6587132  BOS
    ## 7    6286408  BOS
    ## 8    1825200  BOS
    ## 9    4743000  BOS
    ## 10   5000000  BOS
    ## 11   1223653  BOS
    ## 12   3094014  BOS
    ## 13   3578880  BOS
    ## 14   1906440  BOS
    ## 15   8000000  BOS
    ## 16   7806971  CLE
    ## 17     18255  CLE
    ## 18    259626  CLE
    ## 19    268029  CLE
    ## 20      5145  CLE
    ## 21   9700000  CLE
    ## 22  12800000  CLE
    ## 23   1551659  CLE
    ## 24    543471  CLE
    ## 25  21165675  CLE
    ## 26   5239437  CLE
    ## 27  17638063  CLE
    ## 28  30963450  CLE
    ## 29   2500000  CLE
    ## 30  15330435  CLE
    ## 31   1589640  TOR
    ## 32   7330000  TOR
    ## 33   1577280  TOR
    ## 34  26540100  TOR
    ## 35  14200000  TOR
    ## 36    543471  TOR
    ## 37   2703960  TOR
    ## 38  14382022  TOR
    ## 39  12000000  TOR
    ## 40   1921320  TOR
    ## 41    874636  TOR
    ## 42   5300000  TOR
    ## 43   1196040  TOR
    ## 44   6050000  TOR
    ## 45  12250000  TOR
    ## 46   3730653  WAS
    ## 47  22116750  WAS
    ## 48   1200000  WAS
    ## 49   1191480  WAS
    ## 50    543471  WAS
    ## 51  15944154  WAS
    ## 52   5000000  WAS
    ## 53  16957900  WAS
    ## 54  12000000  WAS
    ## 55   7400000  WAS
    ## 56   5893981  WAS
    ## 57    543471  WAS
    ## 58   2870813  WAS
    ## 59   3386598  WAS
    ## 60   1499760  ATL
    ## 61   2708582  ATL
    ## 62  23180275  ATL
    ## 63   8400000  ATL
    ## 64    392478  ATL
    ## 65  15730338  ATL
    ## 66   4000000  ATL
    ## 67   2500000  ATL
    ## 68   4837500  ATL
    ## 69   1015696  ATL
    ## 70  20072033  ATL
    ## 71    418228  ATL
    ## 72   3850000  ATL
    ## 73   2281605  ATL
    ## 74   2995421  MIL
    ## 75  17100000  MIL
    ## 76   5374320  MIL
    ## 77   1551659  MIL
    ## 78  12517606  MIL
    ## 79  15200000  MIL
    ## 80    925000  MIL
    ## 81   9607500  MIL
    ## 82   1403611  MIL
    ## 83  10500000  MIL
    ## 84   1811040  MIL
    ## 85   6348759  MIL
    ## 86   2568600  MIL
    ## 87   2368327  MIL
    ## 88   2700000  IND
    ## 89  10230179  IND
    ## 90   4583450  IND
    ## 91    650000  IND
    ## 92   8800000  IND
    ## 93   1052342  IND
    ## 94   1800000  IND
    ## 95   4000000  IND
    ## 96   4000000  IND
    ## 97  10770000  IND
    ## 98   2463840  IND
    ## 99  18314532  IND
    ## 100  1052342  IND
    ## 101 14153652  IND
    ## 102  3488000  CHI
    ## 103  1453680  CHI
    ## 104  2112480  CHI
    ## 105   874636  CHI
    ## 106  2092200  CHI
    ## 107 23200000  CHI
    ## 108  1015696  CHI
    ## 109  1643040  CHI
    ## 110 17552209  CHI
    ## 111  1709720  CHI
    ## 112  3183526  CHI
    ## 113  5782450  CHI
    ## 114   750000  CHI
    ## 115 14000000  CHI
    ## 116 13219250  CHI
    ## 117  2898000  MIA
    ## 118 15890000  MIA
    ## 119 22116750  MIA
    ## 120  4000000  MIA
    ## 121  5782450  MIA
    ## 122   874636  MIA
    ## 123  2593440  MIA
    ## 124  1227000  MIA
    ## 125   210995  MIA
    ## 126   543471  MIA
    ## 127  5628000  MIA
    ## 128  4000000  MIA
    ## 129  6000000  MIA
    ## 130  1015696  MIA
    ## 131 22116750  DET
    ## 132  6500000  DET
    ## 133  1551659  DET
    ## 134  7000000  DET
    ## 135   874060  DET
    ## 136  1704120  DET
    ## 137  6000000  DET
    ## 138 10991957  DET
    ## 139  3678319  DET
    ## 140  4625000  DET
    ## 141   650000  DET
    ## 142  2255644  DET
    ## 143 14956522  DET
    ## 144  2969880  DET
    ## 145 17200000  DET
    ## 146  1050961  CHO
    ## 147   102898  CHO
    ## 148   874636  CHO
    ## 149  5318313  CHO
    ## 150  2730000  CHO
    ## 151  6511628  CHO
    ## 152   161483  CHO
    ## 153 12000000  CHO
    ## 154  6333333  CHO
    ## 155 12250000  CHO
    ## 156 13000000  CHO
    ## 157 12500000  CHO
    ## 158 20869566  CHO
    ## 159  6000000  CHO
    ## 160   543471  CHO
    ## 161 24559380  NYK
    ## 162   143860  NYK
    ## 163 11242000  NYK
    ## 164 21323250  NYK
    ## 165 17000000  NYK
    ## 166  1015696  NYK
    ## 167  4317720  NYK
    ## 168  3900000  NYK
    ## 169  6191000  NYK
    ## 170   543471  NYK
    ## 171   543471  NYK
    ## 172  2898000  NYK
    ## 173   543471  NYK
    ## 174  1410598  NYK
    ## 175  1375000  NYK
    ## 176  4351320  ORL
    ## 177 17000000  ORL
    ## 178  5000000  ORL
    ## 179  7250000  ORL
    ## 180   980431  ORL
    ## 181  2613600  ORL
    ## 182 17000000  ORL
    ## 183 15000000  ORL
    ## 184  6540000  ORL
    ## 185    31969  ORL
    ## 186  3909840  ORL
    ## 187 11750000  ORL
    ## 188    31969  ORL
    ## 189   950000  ORL
    ## 190 10000000  ORL
    ## 191    31969  PHI
    ## 192  2318280  PHI
    ## 193  9000000  PHI
    ## 194  4788840  PHI
    ## 195  9424084  PHI
    ## 196  4826160  PHI
    ## 197  1514160  PHI
    ## 198  2993040  PHI
    ## 199  1025831  PHI
    ## 200  1015696  PHI
    ## 201  8000000  PHI
    ## 202    89513  PHI
    ## 203   874636  PHI
    ## 204  8550000  PHI
    ## 205  1326960  PHI
    ## 206  6088993  BRK
    ## 207   119494  BRK
    ## 208 21165675  BRK
    ## 209  1562280  BRK
    ## 210  1074145  BRK
    ## 211 11483254  BRK
    ## 212   980431  BRK
    ## 213  3000000  BRK
    ## 214  3333333  BRK
    ## 215  1790902  BRK
    ## 216  2500000  BRK
    ## 217  1395600  BRK
    ## 218   980431  BRK
    ## 219   726672  BRK
    ## 220  9250000  BRK
    ## 221 11131368  GSW
    ## 222  1171560  GSW
    ## 223  1551659  GSW
    ## 224 15330435  GSW
    ## 225  1015696  GSW
    ## 226   980431  GSW
    ## 227  1403611  GSW
    ## 228 26540100  GSW
    ## 229  1182840  GSW
    ## 230 16663575  GSW
    ## 231   383351  GSW
    ## 232   543471  GSW
    ## 233  5782450  GSW
    ## 234 12112359  GSW
    ## 235  2898000  GSW
    ## 236   543471  SAS
    ## 237 10000000  SAS
    ## 238  1551659  SAS
    ## 239   543471  SAS
    ## 240  1180080  SAS
    ## 241  2898000  SAS
    ## 242   165952  SAS
    ## 243   874636  SAS
    ## 244 17638063  SAS
    ## 245  1192080  SAS
    ## 246 20575005  SAS
    ## 247 14000000  SAS
    ## 248  3578948  SAS
    ## 249 15500000  SAS
    ## 250 14445313  SAS
    ## 251   680534  HOU
    ## 252   543471  HOU
    ## 253  1296240  HOU
    ## 254 12385364  HOU
    ## 255   255000  HOU
    ## 256 26540100  HOU
    ## 257   543471  HOU
    ## 258  7000000  HOU
    ## 259  1000000  HOU
    ## 260  6000000  HOU
    ## 261 18735364  HOU
    ## 262  1720560  HOU
    ## 263  7806971  HOU
    ## 264   150000  HOU
    ## 265  1315448  LAC
    ## 266 11000000  LAC
    ## 267 20140838  LAC
    ## 268  1551659  LAC
    ## 269  1273920  LAC
    ## 270 22868828  LAC
    ## 271 21165675  LAC
    ## 272   543471  LAC
    ## 273  7377500  LAC
    ## 274 13253012  LAC
    ## 275  2203000  LAC
    ## 276  1403611  LAC
    ## 277  3500000  LAC
    ## 278  1551659  LAC
    ## 279  5628000  LAC
    ## 280 10154495  UTA
    ## 281  7000000  UTA
    ## 282  3940320  UTA
    ## 283 11050000  UTA
    ## 284  8000000  UTA
    ## 285 16073140  UTA
    ## 286  1015696  UTA
    ## 287  2250000  UTA
    ## 288 11000000  UTA
    ## 289   600000  UTA
    ## 290   937800  UTA
    ## 291  1406520  UTA
    ## 292  2121288  UTA
    ## 293  2433334  UTA
    ## 294  2340600  UTA
    ## 295  5994764  OKC
    ## 296  2183072  OKC
    ## 297  2440200  OKC
    ## 298  2483040  OKC
    ## 299 17145838  OKC
    ## 300   980431  OKC
    ## 301  1191480  OKC
    ## 302  4837500  OKC
    ## 303  3750000  OKC
    ## 304   247991  OKC
    ## 305 26540100  OKC
    ## 306   543471  OKC
    ## 307  3140517  OKC
    ## 308  8950000  OKC
    ## 309  6552960  OKC
    ## 310   945000  MEM
    ## 311  5700000  MEM
    ## 312 22116750  MEM
    ## 313  1369229  MEM
    ## 314  2898000  MEM
    ## 315   980431  MEM
    ## 316  1286160  MEM
    ## 317 21165675  MEM
    ## 318 26540100  MEM
    ## 319  5505618  MEM
    ## 320  3332940  MEM
    ## 321  4264057  MEM
    ## 322  1793760  MEM
    ## 323    83119  MEM
    ## 324 10361445  MEM
    ## 325  7680965  POR
    ## 326 18500000  POR
    ## 327  3219579  POR
    ## 328 24328425  POR
    ## 329  6666667  POR
    ## 330 16393443  POR
    ## 331   600000  POR
    ## 332  1921320  POR
    ## 333  8988764  POR
    ## 334  9213484  POR
    ## 335  2751360  POR
    ## 336   874636  POR
    ## 337  1350120  POR
    ## 338   543471  POR
    ## 339 15050000  DEN
    ## 340  8070175  DEN
    ## 341  3241800  DEN
    ## 342  1655880  DEN
    ## 343  3210840  DEN
    ## 344  4540525  DEN
    ## 345  1987440  DEN
    ## 346 12078652  DEN
    ## 347  1627320  DEN
    ## 348  2328530  DEN
    ## 349  3500000  DEN
    ## 350  1358500  DEN
    ## 351  5000000  DEN
    ## 352  3533333  DEN
    ## 353 11200000  DEN
    ## 354  4600000  NOP
    ## 355 22116750  NOP
    ## 356    20580  NOP
    ## 357   543471  NOP
    ## 358  2978250  NOP
    ## 359 16957900  NOP
    ## 360   576724  NOP
    ## 361  8081363  NOP
    ## 362   173094  NOP
    ## 363 11286518  NOP
    ## 364  9904494  NOP
    ## 365    63938  NOP
    ## 366 11241218  NOP
    ## 367  2090000  NOP
    ## 368   650000  DAL
    ## 369  1015696  DAL
    ## 370  4228000  DAL
    ## 371 25000000  DAL
    ## 372   543471  DAL
    ## 373  8375000  DAL
    ## 374 22116750  DAL
    ## 375  4096950  DAL
    ## 376    63938  DAL
    ## 377  4384490  DAL
    ## 378   543471  DAL
    ## 379   874636  DAL
    ## 380  2898000  DAL
    ## 381 17100000  DAL
    ## 382   207798  DAL
    ## 383  8000000  SAC
    ## 384 12500000  SAC
    ## 385  4008882  SAC
    ## 386  3517200  SAC
    ## 387  5229454  SAC
    ## 388  8000000  SAC
    ## 389  2202240  SAC
    ## 390  8046500  SAC
    ## 391  5200000  SAC
    ## 392  1439880  SAC
    ## 393 13333333  SAC
    ## 394  1188840  SAC
    ## 395  1315448  SAC
    ## 396 10661286  SAC
    ## 397  3551160  SAC
    ## 398  2022240  MIN
    ## 399  6006600  MIN
    ## 400  3500000  MIN
    ## 401  7643979  MIN
    ## 402  2348783  MIN
    ## 403  3911380  MIN
    ## 404  5960160  MIN
    ## 405  3872520  MIN
    ## 406  3800000  MIN
    ## 407   138414  MIN
    ## 408 13550000  MIN
    ## 409  3046299  MIN
    ## 410  1339680  MIN
    ## 411  2240880  MIN
    ## 412  5281680  LAL
    ## 413  7600000  LAL
    ## 414  5332800  LAL
    ## 415    73528  LAL
    ## 416  1034956  LAL
    ## 417 12500000  LAL
    ## 418  3267120  LAL
    ## 419  1207680  LAL
    ## 420 18000000  LAL
    ## 421  1551659  LAL
    ## 422  5443918  LAL
    ## 423  6191000  LAL
    ## 424  1050961  LAL
    ## 425 16000000  LAL
    ## 426  1733880  LAL
    ## 427   874636  PHO
    ## 428  4823621  PHO
    ## 429 12606250  PHO
    ## 430   543471  PHO
    ## 431  2223600  PHO
    ## 432  4276320  PHO
    ## 433    23069  PHO
    ## 434 14000000  PHO
    ## 435 10470000  PHO
    ## 436  4000000  PHO
    ## 437  2941440  PHO
    ## 438   282595  PHO
    ## 439  2128920  PHO
    ## 440   918369  PHO
    ## 441 12415000  PHO

For further information about how to utilize this type of merging, click on the link below to a useful Youtube video! <https://www.youtube.com/watch?v=9JRsHxKCvsg>

Ex 5: Using this new data\_stats dataframe, lets focus in on only the players that are less than 25

``` r
sqldf("SELECT *
      FROM dat_stats2
      WHERE age < 25")
```

    ##                       player points assists position age experience
    ## 1          Demetrius Jackson     10       3       PG  22          0
    ## 2                James Young     68       4       SG  21          2
    ## 3               Jaylen Brown    515      64       SF  20          0
    ## 4              Jordan Mickey     38       7       PF  22          1
    ## 5               Marcus Smart    835     364       SG  22          2
    ## 6               Terry Rozier    410     131       PG  22          1
    ## 7                Edy Tavares      6       1        C  24          1
    ## 8                 Kay Felder    166      58       PG  21          0
    ## 9               Kyrie Irving   1816     418       PG  24          5
    ## 10             Bruno Caboclo     14       4       SF  21          2
    ## 11              Delon Wright    150      57       PG  24          1
    ## 12             Fred VanVleet    107      35       PG  22          0
    ## 13              Jakob Poeltl    165      12        C  21          0
    ## 14         Jonas Valanciunas    959      57        C  24          4
    ## 15            Lucas Nogueira    253      42        C  24          2
    ## 16             Norman Powell    636      82       SG  23          1
    ## 17             Pascal Siakam    229      17       PF  22          0
    ## 18              Bradley Beal   1779     267       SG  23          4
    ## 19          Chris McCullough      1       0       PF  21          1
    ## 20             Daniel Ochefu     24       3        C  23          0
    ## 21               Otto Porter   1075     121       SF  23          3
    ## 22         Sheldon McClellan     90      15       SG  24          0
    ## 23                Trey Burke    285     100       PG  24          3
    ## 24           DeAndre' Bembry    101      28       SF  22          0
    ## 25           Dennis Schroder   1414     499       PG  23          3
    ## 26              Tim Hardaway   1143     182       SG  24          3
    ## 27     Giannis Antetokounmpo   1832     434       SF  22          3
    ## 28             Jabari Parker   1025     142       PF  21          2
    ## 29           Malcolm Brogdon    767     317       SG  24          0
    ## 30             Rashad Vaughn    142      23       SG  20          1
    ## 31                Thon Maker    226      23        C  19          0
    ## 32             Georges Niang     21       5       PF  23          0
    ## 33                 Joe Young     68      15       PG  24          1
    ## 34              Myles Turner   1173     106        C  20          1
    ## 35              Bobby Portis    437      35       PF  21          1
    ## 36             Cameron Payne     54      15       PG  22          1
    ## 37         Cristiano Felicio    316      40        C  24          1
    ## 38          Denzel Valentine    291      63       SG  23          0
    ## 39              Jerian Grant    370     120       PG  24          1
    ## 40               Paul Zipser    240      36       SF  22          0
    ## 41           Josh Richardson    539     140       SG  23          1
    ## 42           Justise Winslow    196      66       SF  20          1
    ## 43               Okaro White     98      21       PF  24          0
    ## 44             Tyler Johnson   1002     233       PG  24          2
    ## 45            Andre Drummond   1105      89        C  23          4
    ## 46           Darrun Hilliard    127      33       SG  23          1
    ## 47            Henry Ellenson     60       7       PF  20          0
    ## 48  Kentavious Caldwell-Pope   1047     193       SG  23          3
    ## 49           Michael Gbinije      4       2       SG  24          0
    ## 50           Stanley Johnson    339     105       SF  20          1
    ## 51             Tobias Harris   1321     142       PF  24          5
    ## 52             Briante Weber     50      16       PG  24          1
    ## 53            Christian Wood     35       2       PF  21          1
    ## 54               Cody Zeller    639      99       PF  24          3
    ## 55            Frank Kaminsky    874     162        C  23          1
    ## 56               Jeremy Lamb    603      75       SG  24          4
    ## 57           Johnny O'Bryant     18       4       PF  23          2
    ## 58    Michael Kidd-Gilchrist    743     114       SF  23          4
    ## 59            Treveon Graham     57       6       SG  23          0
    ## 60            Chasson Randle     95      28       PG  23          0
    ## 61        Kristaps Porzingis   1196      97       PF  21          1
    ## 62          Marshall Plumlee     40      10        C  24          0
    ## 63             Maurice Ndour     98       8       PF  24          0
    ## 64                 Ron Baker    215     107       SG  23          0
    ## 65         Willy Hernangomez    587      96        C  22          0
    ## 66              Aaron Gordon   1019     150       SF  21          2
    ## 67           Bismack Biyombo    483      74        C  24          5
    ## 68             Elfrid Payton   1046     529       PG  22          2
    ## 69             Evan Fournier   1167     202       SG  24          4
    ## 70       Marcus Georges-Hunt     14       3       SG  22          0
    ## 71             Mario Hezonja    317      62       SF  21          1
    ## 72           Patricio Garino      0       0       SG  23          0
    ## 73         Stephen Zimmerman     23       4        C  20          0
    ## 74            Alex Poythress     64       5       PF  23          0
    ## 75               Dario Saric   1040     182       PF  22          0
    ## 76             Jahlil Okafor    590      58        C  21          1
    ## 77               Joel Embiid    627      66        C  22          0
    ## 78           Justin Anderson    203      34       SF  23          1
    ## 79              Nik Stauskas    756     188       SG  23          2
    ## 80            Richaun Holmes    559      58        C  23          1
    ## 81                Shawn Long    148      13        C  24          0
    ## 82            T.J. McConnell    556     534       PG  24          1
    ## 83   Timothe Luwawu-Cabarrot    445      75       SF  21          0
    ## 84            Archie Goodwin     95      23       SG  22          3
    ## 85              Caris LeVert    468     110       SF  22          0
    ## 86          Isaiah Whitehead    543     192       PG  21          0
    ## 87            K.J. McDaniels    126       9       SF  23          2
    ## 88   Rondae Hollis-Jefferson    675     154       SF  22          1
    ## 89         Spencer Dinwiddie    432     185       PG  23          2
    ## 90              Damian Jones     19       0        C  21          0
    ## 91      James Michael McAdoo    147      17       PF  24          2
    ## 92              Kevon Looney    135      29        C  20          1
    ## 93             Patrick McCaw    282      77       SG  21          0
    ## 94               Bryn Forbes     94      23       SG  23          0
    ## 95             Davis Bertans    303      46       PF  24          0
    ## 96           Dejounte Murray    130      48       PG  20          0
    ## 97             Kyle Anderson    246      91       SG  23          2
    ## 98            Chinanu Onuaku     14       3        C  20          0
    ## 99              Clint Capela    818      64        C  22          2
    ## 100            Isaiah Taylor      3       3       PG  22          0
    ## 101             Kyle Wiltjer     13       2       PF  24          0
    ## 102         Montrezl Harrell    527      64        C  23          1
    ## 103               Sam Dekker    504      76       SF  22          1
    ## 104            Troy Williams     58       6       SF  22          0
    ## 105            Austin Rivers    889     204       SG  24          4
    ## 106            Brice Johnson      4       1       PF  22          0
    ## 107            Diamond Stone     10       0        C  19          0
    ## 108               Dante Exum    412     112       PG  21          1
    ## 109            Joel Bolomboy     22       2       PF  23          0
    ## 110                Raul Neto    100      34       PG  24          1
    ## 111              Rodney Hood    748      96       SG  24          2
    ## 112              Rudy Gobert   1137      97        C  24          3
    ## 113               Trey Lyles    440      70       PF  21          1
    ## 114             Alex Abrines    406      40       SG  23          0
    ## 115         Domantas Sabonis    479      82       PF  20          0
    ## 116              Enes Kanter   1033      67        C  24          5
    ## 117             Jerami Grant    421      46       SF  22          2
    ## 118           Semaj Christon    183     130       PG  24          0
    ## 119             Steven Adams    905      86        C  23          3
    ## 120           Victor Oladipo   1067     176       SG  24          3
    ## 121          Andrew Harrison    425     198       PG  22          0
    ## 122            Deyonta Davis     58       2        C  20          0
    ## 123            Jarell Martin    165       8       PF  22          1
    ## 124             Wade Baldwin    106      61       PG  20          0
    ## 125             Wayne Selden     55      12       SG  22          0
    ## 126             Allen Crabbe    845      93       SG  24          3
    ## 127              Jake Layman     78      11       SF  22          0
    ## 128             Jusuf Nurkic    304      63        C  22          2
    ## 129         Maurice Harkless    773      89       SF  23          4
    ## 130           Meyers Leonard    401      71       PF  24          4
    ## 131              Noah Vonleh    327      31       PF  21          2
    ## 132          Pat Connaughton     98      28       SG  24          1
    ## 133           Tim Quarterman     31      11       SG  22          0
    ## 134          Emmanuel Mudiay    603     217       PG  20          1
    ## 135              Gary Harris    851     164       SG  22          2
    ## 136             Jamal Murray    811     170       SG  19          0
    ## 137         Juan Hernangomez    305      29       PF  21          0
    ## 138            Malik Beasley     83      11       SG  20          0
    ## 139             Nikola Jokic   1221     358        C  21          1
    ## 140            Anthony Davis   2099     157        C  23          4
    ## 141             Axel Toupane     11       0       SF  24          1
    ## 142            Cheick Diallo     87       4       PF  20          0
    ## 143               Quinn Cook     52      14       PG  23          0
    ## 144             A.J. Hammons     48       4        C  24          0
    ## 145      Dorian Finney-Smith    350      67       PF  23          0
    ## 146          Harrison Barnes   1518     117       PF  24          4
    ## 147            Jarrod Uthoff     40       9       PF  23          0
    ## 148             Nerlens Noel    188      20        C  22          2
    ## 149         Nicolas Brussino    150      47       SF  23          0
    ## 150             Yogi Ferrell    408     155       PG  23          0
    ## 151             Ben McLemore    495      51       SG  23          3
    ## 152              Buddy Hield    378      44       SG  23          0
    ## 153     Georgios Papagiannis    124      20        C  19          0
    ## 154       Malachi Richardson     79      11       SG  21          0
    ## 155          Skal Labissiere    289      27       PF  20          0
    ## 156      Willie Cauley-Stein    611      80        C  23          1
    ## 157           Andrew Wiggins   1933     189       SF  21          2
    ## 158       Karl-Anthony Towns   2061     220        C  21          1
    ## 159                Kris Dunn    293     188       PG  22          0
    ## 160         Shabazz Muhammad    772      35       SF  24          3
    ## 161               Tyus Jones    209     156       PG  20          1
    ## 162              Zach LaVine    889     139       SG  21          2
    ## 163           Brandon Ingram    740     166       SF  19          0
    ## 164         D'Angelo Russell    984     303       PG  20          1
    ## 165              David Nwaba    120      14       SG  24          0
    ## 166              Ivica Zubac    284      30        C  19          0
    ## 167          Jordan Clarkson   1205     213       SG  24          2
    ## 168            Julius Randle    975     264       PF  22          2
    ## 169          Larry Nance Jr.    449      96       PF  24          1
    ## 170              Tyler Ennis    170      52       PG  22          2
    ## 171            Alan Williams    346      23        C  24          1
    ## 172                 Alex Len    613      44        C  23          3
    ## 173            Derrick Jones    168      12       SF  19          0
    ## 174             Devin Booker   1726     268       SG  20          1
    ## 175            Dragan Bender    146      23       PF  19          0
    ## 176          Marquese Chriss    753      60       PF  19          0
    ## 177              T.J. Warren    951      75       SF  23          2
    ## 178               Tyler Ulis    444     226       PG  21          0
    ##       salary team
    ## 1    1450000  BOS
    ## 2    1825200  BOS
    ## 3    4743000  BOS
    ## 4    1223653  BOS
    ## 5    3578880  BOS
    ## 6    1906440  BOS
    ## 7       5145  CLE
    ## 8     543471  CLE
    ## 9   17638063  CLE
    ## 10   1589640  TOR
    ## 11   1577280  TOR
    ## 12    543471  TOR
    ## 13   2703960  TOR
    ## 14  14382022  TOR
    ## 15   1921320  TOR
    ## 16    874636  TOR
    ## 17   1196040  TOR
    ## 18  22116750  WAS
    ## 19   1191480  WAS
    ## 20    543471  WAS
    ## 21   5893981  WAS
    ## 22    543471  WAS
    ## 23   3386598  WAS
    ## 24   1499760  ATL
    ## 25   2708582  ATL
    ## 26   2281605  ATL
    ## 27   2995421  MIL
    ## 28   5374320  MIL
    ## 29    925000  MIL
    ## 30   1811040  MIL
    ## 31   2568600  MIL
    ## 32    650000  IND
    ## 33   1052342  IND
    ## 34   2463840  IND
    ## 35   1453680  CHI
    ## 36   2112480  CHI
    ## 37    874636  CHI
    ## 38   2092200  CHI
    ## 39   1643040  CHI
    ## 40    750000  CHI
    ## 41    874636  MIA
    ## 42   2593440  MIA
    ## 43    210995  MIA
    ## 44   5628000  MIA
    ## 45  22116750  DET
    ## 46    874060  DET
    ## 47   1704120  DET
    ## 48   3678319  DET
    ## 49    650000  DET
    ## 50   2969880  DET
    ## 51  17200000  DET
    ## 52    102898  CHO
    ## 53    874636  CHO
    ## 54   5318313  CHO
    ## 55   2730000  CHO
    ## 56   6511628  CHO
    ## 57    161483  CHO
    ## 58  13000000  CHO
    ## 59    543471  CHO
    ## 60    143860  NYK
    ## 61   4317720  NYK
    ## 62    543471  NYK
    ## 63    543471  NYK
    ## 64    543471  NYK
    ## 65   1375000  NYK
    ## 66   4351320  ORL
    ## 67  17000000  ORL
    ## 68   2613600  ORL
    ## 69  17000000  ORL
    ## 70     31969  ORL
    ## 71   3909840  ORL
    ## 72     31969  ORL
    ## 73    950000  ORL
    ## 74     31969  PHI
    ## 75   2318280  PHI
    ## 76   4788840  PHI
    ## 77   4826160  PHI
    ## 78   1514160  PHI
    ## 79   2993040  PHI
    ## 80   1025831  PHI
    ## 81     89513  PHI
    ## 82    874636  PHI
    ## 83   1326960  PHI
    ## 84    119494  BRK
    ## 85   1562280  BRK
    ## 86   1074145  BRK
    ## 87   3333333  BRK
    ## 88   1395600  BRK
    ## 89    726672  BRK
    ## 90   1171560  GSW
    ## 91    980431  GSW
    ## 92   1182840  GSW
    ## 93    543471  GSW
    ## 94    543471  SAS
    ## 95    543471  SAS
    ## 96   1180080  SAS
    ## 97   1192080  SAS
    ## 98    543471  HOU
    ## 99   1296240  HOU
    ## 100   255000  HOU
    ## 101   543471  HOU
    ## 102  1000000  HOU
    ## 103  1720560  HOU
    ## 104   150000  HOU
    ## 105 11000000  LAC
    ## 106  1273920  LAC
    ## 107   543471  LAC
    ## 108  3940320  UTA
    ## 109   600000  UTA
    ## 110   937800  UTA
    ## 111  1406520  UTA
    ## 112  2121288  UTA
    ## 113  2340600  UTA
    ## 114  5994764  OKC
    ## 115  2440200  OKC
    ## 116 17145838  OKC
    ## 117   980431  OKC
    ## 118   543471  OKC
    ## 119  3140517  OKC
    ## 120  6552960  OKC
    ## 121   945000  MEM
    ## 122  1369229  MEM
    ## 123  1286160  MEM
    ## 124  1793760  MEM
    ## 125    83119  MEM
    ## 126 18500000  POR
    ## 127   600000  POR
    ## 128  1921320  POR
    ## 129  8988764  POR
    ## 130  9213484  POR
    ## 131  2751360  POR
    ## 132   874636  POR
    ## 133   543471  POR
    ## 134  3241800  DEN
    ## 135  1655880  DEN
    ## 136  3210840  DEN
    ## 137  1987440  DEN
    ## 138  1627320  DEN
    ## 139  1358500  DEN
    ## 140 22116750  NOP
    ## 141    20580  NOP
    ## 142   543471  NOP
    ## 143    63938  NOP
    ## 144   650000  DAL
    ## 145   543471  DAL
    ## 146 22116750  DAL
    ## 147    63938  DAL
    ## 148  4384490  DAL
    ## 149   543471  DAL
    ## 150   207798  DAL
    ## 151  4008882  SAC
    ## 152  3517200  SAC
    ## 153  2202240  SAC
    ## 154  1439880  SAC
    ## 155  1188840  SAC
    ## 156  3551160  SAC
    ## 157  6006600  MIN
    ## 158  5960160  MIN
    ## 159  3872520  MIN
    ## 160  3046299  MIN
    ## 161  1339680  MIN
    ## 162  2240880  MIN
    ## 163  5281680  LAL
    ## 164  5332800  LAL
    ## 165    73528  LAL
    ## 166  1034956  LAL
    ## 167 12500000  LAL
    ## 168  3267120  LAL
    ## 169  1207680  LAL
    ## 170  1733880  LAL
    ## 171   874636  PHO
    ## 172  4823621  PHO
    ## 173   543471  PHO
    ## 174  2223600  PHO
    ## 175  4276320  PHO
    ## 176  2941440  PHO
    ## 177  2128920  PHO
    ## 178   918369  PHO

The Star symbol is a very useful notation for this syntax as it pertains to selecting all of the data: <https://www.r-bloggers.com/manipulating-data-frames-using-sqldf-a-brief-overview/> can be used to learn more about this notation.

For individuals that are well adjusted to SQL, yet need to improve upon their work in R, sqldf will be the easiest transitioning mechanism. Fun fact about SQL:SQL was invented in 1970 by Donald Chamberlin and is the largest database language.

In order to plot certain charts we know would like to utilize ggplot2:

``` r
library(ggplot2)
```

Ex 6: Let's make a bar-chart of the salary versus points for individuals that are 30 or older in age!

``` r
setwd("~/Stat133/Stat133-hws-fall17/post01/images")
```

``` r
dat_pts_sal <- sqldf("SELECT points, salary
                      FROM dat_stats2
                      WHERE age >= 30")
gg_pts_sal <- ggplot(data = dat_pts_sal, aes(x = points, y = salary)) + geom_point() +ggtitle("Points versus Salary")
```

Let's now export this scatterplot to the images folder!

``` r
getwd()
```

    ## [1] "/Users/matthewbrennan/stat133/stat133-hws-fall17/post01/code"

``` r
ggsave(filename = "points_salary_30s.pdf", plot = gg_pts_sal, width = 6, height = 4)
```

Let's now try to master the Group By aspect of sqldf:

Suppose we want to get all of the individuals making more than 10 mil, and we want to get the count of how many there are on each team. The Group By aspect can be a very useful and easy way to perform this.

``` r
sal_grouped <- sqldf("SELECT team, COUNT (player) as occurences
                     FROM dat_stats2
                     WHERE salary > 10000000
                     GROUP BY team")
sal_grouped
```

    ##    team occurences
    ## 1   ATL          3
    ## 2   BOS          2
    ## 3   BRK          2
    ## 4   CHI          4
    ## 5   CHO          5
    ## 6   CLE          5
    ## 7   DAL          3
    ## 8   DEN          3
    ## 9   DET          4
    ## 10  GSW          5
    ## 11  HOU          3
    ## 12  IND          4
    ## 13  LAC          5
    ## 14  LAL          3
    ## 15  MEM          4
    ## 16  MIA          2
    ## 17  MIL          4
    ## 18  MIN          1
    ## 19  NOP          4
    ## 20  NYK          4
    ## 21  OKC          2
    ## 22  ORL          4
    ## 23  PHO          4
    ## 24  POR          3
    ## 25  SAC          3
    ## 26  SAS          5
    ## 27  TOR          5
    ## 28  UTA          4
    ## 29  WAS          4

For more information about the GROUP BY command visit <http://analyticsplaybook.org/api/learn_sql_30_minutes.html> to watch a video.

Let's now upload a histogram of the amounts to images as a pdf in order to keep track of the results:

``` r
setwd("~/Stat133/Stat133-hws-fall17/post01/images")
```

``` r
pdf(file = "histogram-salary.pdf", width = 7, height = 5)
hist(sal_grouped$occurences, xlab = "Making over 10 mil.", main = "Number of players making 10 mil. per team")
dev.off()
```

    ## quartz_off_screen 
    ##                 2

Let's now work with the intersection and EXCEPT aspects of sqldf in order to solidify all of the possible methods by which one could create a dataframe using this package:

Since we have created a variety of data\_frames, such as dat\_stats2 which we constructed from merging dat\_stats and dat1, we can now work backwards to see what these original groups have in common with the newer dat\_stats2:

Let's create a new data\_frame, dat\_sal\_gt\_10mil, consisting of only players that make more than 7 mil!

``` r
dat_sal_gt_10mil <- sqldf("SELECT *
                          FROM dat_stats2
                          WHERE salary > 10000000")
dat_sal_gt_10mil
```

    ##                     player points assists position age experience   salary
    ## 1               Al Horford    952     337        C  30          9 26540100
    ## 2             Amir Johnson    520     140       PF  29         11 12000000
    ## 3               J.R. Smith    351      62       SG  31         12 12800000
    ## 4               Kevin Love   1142     116       PF  28          8 21165675
    ## 5             Kyrie Irving   1816     418       PG  24          5 17638063
    ## 6             LeBron James   1954     646       SF  32         13 30963450
    ## 7         Tristan Thompson    630      77        C  25          5 15330435
    ## 8            DeMar DeRozan   2020     290       SG  27          7 26540100
    ## 9          DeMarre Carroll    638      74       SF  30          7 14200000
    ## 10       Jonas Valanciunas    959      57        C  24          4 14382022
    ## 11              Kyle Lowry   1344     417       PG  30         10 12000000
    ## 12             Serge Ibaka    327      15       PF  27          7 12250000
    ## 13            Bradley Beal   1779     267       SG  23          4 22116750
    ## 14             Ian Mahinmi    173      19        C  30          8 15944154
    ## 15               John Wall   1805     831       PG  26          6 16957900
    ## 16           Marcin Gortat    883     121        C  32          9 12000000
    ## 17           Dwight Howard   1002     104        C  31         12 23180275
    ## 18           Kent Bazemore    801     177       SF  27          4 15730338
    ## 19            Paul Millsap   1246     252       PF  31         10 20072033
    ## 20             Greg Monroe    951     187        C  26          6 17100000
    ## 21             John Henson    392      57        C  26          4 12517606
    ## 22         Khris Middleton    426      99       SF  25          4 15200000
    ## 23         Mirza Teletovic    451      48       PF  31          4 10500000
    ## 24            Al Jefferson    535      57        C  32         12 10230179
    ## 25             Monta Ellis    630     236       SG  31         11 10770000
    ## 26             Paul George   1775     251       SF  26          6 18314532
    ## 27          Thaddeus Young    814     122       PF  28          9 14153652
    ## 28             Dwyane Wade   1096     229       SG  35         13 23200000
    ## 29            Jimmy Butler   1816     417       SF  27          5 17552209
    ## 30             Rajon Rondo    538     461       PG  30         10 14000000
    ## 31             Robin Lopez    839      80        C  28          8 13219250
    ## 32            Goran Dragic   1483     423       PG  30          8 15890000
    ## 33        Hassan Whiteside   1309      57        C  27          4 22116750
    ## 34          Andre Drummond   1105      89        C  23          4 22116750
    ## 35               Jon Leuer    767     111       PF  27          5 10991957
    ## 36          Reggie Jackson    752     270       PG  26          5 14956522
    ## 37           Tobias Harris   1321     142       PF  24          5 17200000
    ## 38            Kemba Walker   1830     435       PG  26          5 12000000
    ## 39         Marvin Williams    849     106       PF  30         11 12250000
    ## 40  Michael Kidd-Gilchrist    743     114       SF  23          4 13000000
    ## 41           Miles Plumlee     31       3        C  28          4 12500000
    ## 42           Nicolas Batum   1164     455       SG  28          8 20869566
    ## 43         Carmelo Anthony   1659     213       SF  32         13 24559380
    ## 44            Courtney Lee    835     179       SG  31          8 11242000
    ## 45            Derrick Rose   1154     283       PG  28          7 21323250
    ## 46             Joakim Noah    232     103        C  31          9 17000000
    ## 47         Bismack Biyombo    483      74        C  24          5 17000000
    ## 48           Evan Fournier   1167     202       SG  24          4 17000000
    ## 49              Jeff Green    638      81       PF  30          8 15000000
    ## 50          Nikola Vucevic   1096     208        C  26          5 11750000
    ## 51             Brook Lopez   1539     176        C  28          8 21165675
    ## 52              Jeremy Lin    523     184       PG  28          6 11483254
    ## 53          Andre Iguodala    574     262       SF  33         12 11131368
    ## 54          Draymond Green    776     533       PF  26          4 15330435
    ## 55            Kevin Durant   1555     300       SF  28          9 26540100
    ## 56           Klay Thompson   1742     160       SG  26          5 16663575
    ## 57           Stephen Curry   1999     523       PG  28          7 12112359
    ## 58           Kawhi Leonard   1888     260       SF  25          5 17638063
    ## 59       LaMarcus Aldridge   1243     139       PF  31         10 20575005
    ## 60           Manu Ginobili    517     183       SG  39         14 14000000
    ## 61               Pau Gasol    792     150        C  36         15 15500000
    ## 62             Tony Parker    638     285       PG  34         15 14445313
    ## 63             Eric Gordon   1217     188       SG  28          8 12385364
    ## 64            James Harden   2356     906       PG  27          7 26540100
    ## 65           Ryan Anderson    979      68       PF  28          8 18735364
    ## 66           Austin Rivers    889     204       SG  24          4 11000000
    ## 67           Blake Griffin   1316     300       PF  27          6 20140838
    ## 68              Chris Paul   1104     563       PG  31         11 22868828
    ## 69          DeAndre Jordan   1029      96        C  28          8 21165675
    ## 70          Jamal Crawford   1008     213       SG  36         16 13253012
    ## 71              Alec Burks    283      30       SG  25          5 10154495
    ## 72          Derrick Favors    476      56       PF  25          6 11050000
    ## 73          Gordon Hayward   1601     252       SF  26          6 16073140
    ## 74             Joe Johnson    715     144       SF  35         15 11000000
    ## 75             Enes Kanter   1033      67        C  24          5 17145838
    ## 76       Russell Westbrook   2558     840       PG  28          8 26540100
    ## 77        Chandler Parsons    210      55       SF  28          5 22116750
    ## 78              Marc Gasol   1446     338        C  32          8 21165675
    ## 79             Mike Conley   1415     433       PG  29          9 26540100
    ## 80           Zach Randolph   1028     122       PF  35         15 10361445
    ## 81            Allen Crabbe    845      93       SG  24          3 18500000
    ## 82          Damian Lillard   2024     439       PG  26          4 24328425
    ## 83             Evan Turner    586     205       SF  28          6 16393443
    ## 84        Danilo Gallinari   1145     136       SF  28          7 15050000
    ## 85          Kenneth Faried    587      55       PF  27          5 12078652
    ## 86         Wilson Chandler   1117     143       SF  29          8 11200000
    ## 87           Anthony Davis   2099     157        C  23          4 22116750
    ## 88        DeMarcus Cousins    414      66        C  26          6 16957900
    ## 89            Jrue Holiday   1029     488       PG  26          7 11286518
    ## 90            Solomon Hill    563     141       SF  25          3 11241218
    ## 91           Dirk Nowitzki    769      82       PF  38         18 25000000
    ## 92         Harrison Barnes   1518     117       PF  24          4 22116750
    ## 93         Wesley Matthews    986     210       SG  30          7 17100000
    ## 94           Arron Afflalo    515      78       SG  31          9 12500000
    ## 95                Rudy Gay    562      82       SF  30         10 13333333
    ## 96            Tyreke Evans    163      33       SF  27          7 10661286
    ## 97             Ricky Rubio    836     682       PG  26          5 13550000
    ## 98         Jordan Clarkson   1205     213       SG  24          2 12500000
    ## 99               Luol Deng    425      74       SF  31         12 18000000
    ## 100         Timofey Mozgov    401      43        C  30          6 16000000
    ## 101         Brandon Knight    595     130       SG  25          5 12606250
    ## 102           Eric Bledsoe   1390     418       PG  27          6 14000000
    ## 103           Jared Dudley    434     121       PF  31          9 10470000
    ## 104         Tyson Chandler    397      30        C  34         15 12415000
    ##     team
    ## 1    BOS
    ## 2    BOS
    ## 3    CLE
    ## 4    CLE
    ## 5    CLE
    ## 6    CLE
    ## 7    CLE
    ## 8    TOR
    ## 9    TOR
    ## 10   TOR
    ## 11   TOR
    ## 12   TOR
    ## 13   WAS
    ## 14   WAS
    ## 15   WAS
    ## 16   WAS
    ## 17   ATL
    ## 18   ATL
    ## 19   ATL
    ## 20   MIL
    ## 21   MIL
    ## 22   MIL
    ## 23   MIL
    ## 24   IND
    ## 25   IND
    ## 26   IND
    ## 27   IND
    ## 28   CHI
    ## 29   CHI
    ## 30   CHI
    ## 31   CHI
    ## 32   MIA
    ## 33   MIA
    ## 34   DET
    ## 35   DET
    ## 36   DET
    ## 37   DET
    ## 38   CHO
    ## 39   CHO
    ## 40   CHO
    ## 41   CHO
    ## 42   CHO
    ## 43   NYK
    ## 44   NYK
    ## 45   NYK
    ## 46   NYK
    ## 47   ORL
    ## 48   ORL
    ## 49   ORL
    ## 50   ORL
    ## 51   BRK
    ## 52   BRK
    ## 53   GSW
    ## 54   GSW
    ## 55   GSW
    ## 56   GSW
    ## 57   GSW
    ## 58   SAS
    ## 59   SAS
    ## 60   SAS
    ## 61   SAS
    ## 62   SAS
    ## 63   HOU
    ## 64   HOU
    ## 65   HOU
    ## 66   LAC
    ## 67   LAC
    ## 68   LAC
    ## 69   LAC
    ## 70   LAC
    ## 71   UTA
    ## 72   UTA
    ## 73   UTA
    ## 74   UTA
    ## 75   OKC
    ## 76   OKC
    ## 77   MEM
    ## 78   MEM
    ## 79   MEM
    ## 80   MEM
    ## 81   POR
    ## 82   POR
    ## 83   POR
    ## 84   DEN
    ## 85   DEN
    ## 86   DEN
    ## 87   NOP
    ## 88   NOP
    ## 89   NOP
    ## 90   NOP
    ## 91   DAL
    ## 92   DAL
    ## 93   DAL
    ## 94   SAC
    ## 95   SAC
    ## 96   SAC
    ## 97   MIN
    ## 98   LAL
    ## 99   LAL
    ## 100  LAL
    ## 101  PHO
    ## 102  PHO
    ## 103  PHO
    ## 104  PHO

Now, let's use Intersect in order to see what it does:

``` r
sqldf("SELECT player, points
      FROM dat_sal_gt_10mil
      INTERSECT
      SELECT player, points
      FROM dat_stats")
```

    ##                     player points
    ## 1               Al Horford    952
    ## 2             Al Jefferson    535
    ## 3               Alec Burks    283
    ## 4             Allen Crabbe    845
    ## 5             Amir Johnson    520
    ## 6           Andre Drummond   1105
    ## 7           Andre Iguodala    574
    ## 8            Anthony Davis   2099
    ## 9            Arron Afflalo    515
    ## 10           Austin Rivers    889
    ## 11         Bismack Biyombo    483
    ## 12           Blake Griffin   1316
    ## 13            Bradley Beal   1779
    ## 14          Brandon Knight    595
    ## 15             Brook Lopez   1539
    ## 16         Carmelo Anthony   1659
    ## 17        Chandler Parsons    210
    ## 18              Chris Paul   1104
    ## 19            Courtney Lee    835
    ## 20          Damian Lillard   2024
    ## 21        Danilo Gallinari   1145
    ## 22          DeAndre Jordan   1029
    ## 23           DeMar DeRozan   2020
    ## 24        DeMarcus Cousins    414
    ## 25         DeMarre Carroll    638
    ## 26          Derrick Favors    476
    ## 27            Derrick Rose   1154
    ## 28           Dirk Nowitzki    769
    ## 29          Draymond Green    776
    ## 30           Dwight Howard   1002
    ## 31             Dwyane Wade   1096
    ## 32             Enes Kanter   1033
    ## 33            Eric Bledsoe   1390
    ## 34             Eric Gordon   1217
    ## 35           Evan Fournier   1167
    ## 36             Evan Turner    586
    ## 37            Goran Dragic   1483
    ## 38          Gordon Hayward   1601
    ## 39             Greg Monroe    951
    ## 40         Harrison Barnes   1518
    ## 41        Hassan Whiteside   1309
    ## 42             Ian Mahinmi    173
    ## 43              J.R. Smith    351
    ## 44          Jamal Crawford   1008
    ## 45            James Harden   2356
    ## 46            Jared Dudley    434
    ## 47              Jeff Green    638
    ## 48              Jeremy Lin    523
    ## 49            Jimmy Butler   1816
    ## 50             Joakim Noah    232
    ## 51             Joe Johnson    715
    ## 52             John Henson    392
    ## 53               John Wall   1805
    ## 54               Jon Leuer    767
    ## 55       Jonas Valanciunas    959
    ## 56         Jordan Clarkson   1205
    ## 57            Jrue Holiday   1029
    ## 58           Kawhi Leonard   1888
    ## 59            Kemba Walker   1830
    ## 60          Kenneth Faried    587
    ## 61           Kent Bazemore    801
    ## 62            Kevin Durant   1555
    ## 63              Kevin Love   1142
    ## 64         Khris Middleton    426
    ## 65           Klay Thompson   1742
    ## 66              Kyle Lowry   1344
    ## 67            Kyrie Irving   1816
    ## 68       LaMarcus Aldridge   1243
    ## 69            LeBron James   1954
    ## 70               Luol Deng    425
    ## 71           Manu Ginobili    517
    ## 72              Marc Gasol   1446
    ## 73           Marcin Gortat    883
    ## 74         Marvin Williams    849
    ## 75  Michael Kidd-Gilchrist    743
    ## 76             Mike Conley   1415
    ## 77           Miles Plumlee     31
    ## 78         Mirza Teletovic    451
    ## 79             Monta Ellis    630
    ## 80           Nicolas Batum   1164
    ## 81          Nikola Vucevic   1096
    ## 82               Pau Gasol    792
    ## 83             Paul George   1775
    ## 84            Paul Millsap   1246
    ## 85             Rajon Rondo    538
    ## 86          Reggie Jackson    752
    ## 87             Ricky Rubio    836
    ## 88             Robin Lopez    839
    ## 89                Rudy Gay    562
    ## 90       Russell Westbrook   2558
    ## 91           Ryan Anderson    979
    ## 92             Serge Ibaka    327
    ## 93            Solomon Hill    563
    ## 94           Stephen Curry   1999
    ## 95          Thaddeus Young    814
    ## 96          Timofey Mozgov    401
    ## 97           Tobias Harris   1321
    ## 98             Tony Parker    638
    ## 99        Tristan Thompson    630
    ## 100           Tyreke Evans    163
    ## 101         Tyson Chandler    397
    ## 102        Wesley Matthews    986
    ## 103        Wilson Chandler   1117
    ## 104          Zach Randolph   1028

You see that the results are only the player, points from dat\_stats that are in common between the two data\_frames. In the next example one can see that the switching up the order should give the exact same results:

``` r
sqldf("SELECT player, points
      FROM dat_stats 
      INTERSECT
      SELECT player, points
      FROM dat_sal_gt_10mil")
```

    ##                     player points
    ## 1               Al Horford    952
    ## 2             Al Jefferson    535
    ## 3               Alec Burks    283
    ## 4             Allen Crabbe    845
    ## 5             Amir Johnson    520
    ## 6           Andre Drummond   1105
    ## 7           Andre Iguodala    574
    ## 8            Anthony Davis   2099
    ## 9            Arron Afflalo    515
    ## 10           Austin Rivers    889
    ## 11         Bismack Biyombo    483
    ## 12           Blake Griffin   1316
    ## 13            Bradley Beal   1779
    ## 14          Brandon Knight    595
    ## 15             Brook Lopez   1539
    ## 16         Carmelo Anthony   1659
    ## 17        Chandler Parsons    210
    ## 18              Chris Paul   1104
    ## 19            Courtney Lee    835
    ## 20          Damian Lillard   2024
    ## 21        Danilo Gallinari   1145
    ## 22          DeAndre Jordan   1029
    ## 23           DeMar DeRozan   2020
    ## 24        DeMarcus Cousins    414
    ## 25         DeMarre Carroll    638
    ## 26          Derrick Favors    476
    ## 27            Derrick Rose   1154
    ## 28           Dirk Nowitzki    769
    ## 29          Draymond Green    776
    ## 30           Dwight Howard   1002
    ## 31             Dwyane Wade   1096
    ## 32             Enes Kanter   1033
    ## 33            Eric Bledsoe   1390
    ## 34             Eric Gordon   1217
    ## 35           Evan Fournier   1167
    ## 36             Evan Turner    586
    ## 37            Goran Dragic   1483
    ## 38          Gordon Hayward   1601
    ## 39             Greg Monroe    951
    ## 40         Harrison Barnes   1518
    ## 41        Hassan Whiteside   1309
    ## 42             Ian Mahinmi    173
    ## 43              J.R. Smith    351
    ## 44          Jamal Crawford   1008
    ## 45            James Harden   2356
    ## 46            Jared Dudley    434
    ## 47              Jeff Green    638
    ## 48              Jeremy Lin    523
    ## 49            Jimmy Butler   1816
    ## 50             Joakim Noah    232
    ## 51             Joe Johnson    715
    ## 52             John Henson    392
    ## 53               John Wall   1805
    ## 54               Jon Leuer    767
    ## 55       Jonas Valanciunas    959
    ## 56         Jordan Clarkson   1205
    ## 57            Jrue Holiday   1029
    ## 58           Kawhi Leonard   1888
    ## 59            Kemba Walker   1830
    ## 60          Kenneth Faried    587
    ## 61           Kent Bazemore    801
    ## 62            Kevin Durant   1555
    ## 63              Kevin Love   1142
    ## 64         Khris Middleton    426
    ## 65           Klay Thompson   1742
    ## 66              Kyle Lowry   1344
    ## 67            Kyrie Irving   1816
    ## 68       LaMarcus Aldridge   1243
    ## 69            LeBron James   1954
    ## 70               Luol Deng    425
    ## 71           Manu Ginobili    517
    ## 72              Marc Gasol   1446
    ## 73           Marcin Gortat    883
    ## 74         Marvin Williams    849
    ## 75  Michael Kidd-Gilchrist    743
    ## 76             Mike Conley   1415
    ## 77           Miles Plumlee     31
    ## 78         Mirza Teletovic    451
    ## 79             Monta Ellis    630
    ## 80           Nicolas Batum   1164
    ## 81          Nikola Vucevic   1096
    ## 82               Pau Gasol    792
    ## 83             Paul George   1775
    ## 84            Paul Millsap   1246
    ## 85             Rajon Rondo    538
    ## 86          Reggie Jackson    752
    ## 87             Ricky Rubio    836
    ## 88             Robin Lopez    839
    ## 89                Rudy Gay    562
    ## 90       Russell Westbrook   2558
    ## 91           Ryan Anderson    979
    ## 92             Serge Ibaka    327
    ## 93            Solomon Hill    563
    ## 94           Stephen Curry   1999
    ## 95          Thaddeus Young    814
    ## 96          Timofey Mozgov    401
    ## 97           Tobias Harris   1321
    ## 98             Tony Parker    638
    ## 99        Tristan Thompson    630
    ## 100           Tyreke Evans    163
    ## 101         Tyson Chandler    397
    ## 102        Wesley Matthews    986
    ## 103        Wilson Chandler   1117
    ## 104          Zach Randolph   1028

Furthermore, one can utilize the EXCEPT command to identify the rows that the first data\_frame has that the second data\_frame does not:

``` r
sqldf("SELECT player, points
      FROM dat_sal_gt_10mil
      EXCEPT
      SELECT player, points
      FROM dat_stats")
```

    ## [1] player points
    ## <0 rows> (or 0-length row.names)

It is not surprising that the results of the previous command did not provide any rows as the first data\_frame listed was a sub-frame of the second one. The next example should provide more relevant information as this command comprises all of the rows that are in the larger data\_frame that do not appear in the smaller one.

``` r
sqldf("SELECT player, points
      FROM dat_stats
      EXCEPT
      SELECT player, points
      FROM dat_sal_gt_10mil")
```

    ##                       player points
    ## 1               A.J. Hammons     48
    ## 2               Aaron Brooks    322
    ## 3               Aaron Gordon   1019
    ## 4              Adreian Payne     63
    ## 5            Al-Farouq Aminu    532
    ## 6              Alan Anderson     86
    ## 7              Alan Williams    346
    ## 8               Alex Abrines    406
    ## 9                   Alex Len    613
    ## 10            Alex Poythress     64
    ## 11             Alexis Ajinca    207
    ## 12            Andre Roberson    522
    ## 13           Andrew Harrison    425
    ## 14          Andrew Nicholson     30
    ## 15            Andrew Wiggins   1933
    ## 16            Anthony Morrow     41
    ## 17          Anthony Tolliver    461
    ## 18            Archie Goodwin     95
    ## 19               Aron Baynes    365
    ## 20             Avery Bradley    894
    ## 21              Axel Toupane     11
    ## 22              Ben McLemore    495
    ## 23                Beno Udrih    227
    ## 24          Boban Marjanovic    191
    ## 25               Bobby Brown     62
    ## 26              Bobby Portis    437
    ## 27          Bojan Bogdanovic    330
    ## 28                Boris Diaw    338
    ## 29            Brandan Wright    189
    ## 30              Brandon Bass    292
    ## 31            Brandon Ingram    740
    ## 32          Brandon Jennings     81
    ## 33              Brandon Rush    197
    ## 34             Brian Roberts    142
    ## 35             Briante Weber     50
    ## 36             Brice Johnson      4
    ## 37             Bruno Caboclo     14
    ## 38               Bryn Forbes     94
    ## 39               Buddy Hield    378
    ## 40             C.J. McCollum   1837
    ## 41                C.J. Miles    815
    ## 42               C.J. Watson    281
    ## 43             Cameron Payne     54
    ## 44              Caris LeVert    468
    ## 45             Channing Frye    676
    ## 46            Chasson Randle     95
    ## 47             Cheick Diallo     87
    ## 48            Chinanu Onuaku     14
    ## 49          Chris McCullough      1
    ## 50            Christian Wood     35
    ## 51              Clint Capela    818
    ## 52               Cody Zeller    639
    ## 53              Cole Aldrich    105
    ## 54              Corey Brewer    129
    ## 55               Cory Joseph    740
    ## 56         Cristiano Felicio    316
    ## 57          D'Angelo Russell    984
    ## 58             D.J. Augustin    616
    ## 59             Dahntay Jones      9
    ## 60              Damian Jones     19
    ## 61              Damjan Rudez     82
    ## 62             Daniel Ochefu     24
    ## 63               Danny Green    497
    ## 64          Dante Cunningham    435
    ## 65                Dante Exum    412
    ## 66               Dario Saric   1040
    ## 67            Darrell Arthur    262
    ## 68           Darren Collison    900
    ## 69           Darrun Hilliard    127
    ## 70                 David Lee    576
    ## 71               David Nwaba    120
    ## 72                David West    316
    ## 73             Davis Bertans    303
    ## 74           DeAndre Liggins      8
    ## 75           DeAndre' Bembry    101
    ## 76           Dejounte Murray    130
    ## 77              Delon Wright    150
    ## 78         Demetrius Jackson     10
    ## 79           Dennis Schroder   1414
    ## 80          Denzel Valentine    291
    ## 81            Deron Williams    179
    ## 82             Derrick Jones    168
    ## 83          Derrick Williams    156
    ## 84              Devin Booker   1726
    ## 85              Devin Harris    437
    ## 86            Dewayne Dedmon    387
    ## 87             Deyonta Davis     58
    ## 88             Diamond Stone     10
    ## 89              Dion Waiters    729
    ## 90          Domantas Sabonis    479
    ## 91        Donatas Motiejunas    150
    ## 92       Dorian Finney-Smith    350
    ## 93            Doug McDermott    145
    ## 94             Dragan Bender    146
    ## 95             Dwight Powell    516
    ## 96             E'Twaun Moore    700
    ## 97                  Ed Davis    200
    ## 98               Edy Tavares      6
    ## 99             Elfrid Payton   1046
    ## 100           Elijah Millsap      3
    ## 101          Emmanuel Mudiay    603
    ## 102           Ersan Ilyasova    270
    ## 103           Frank Kaminsky    874
    ## 104            Fred VanVleet    107
    ## 105           Garrett Temple    506
    ## 106              Gary Harris    851
    ## 107              George Hill    829
    ## 108            Georges Niang     21
    ## 109     Georgios Papagiannis    124
    ## 110             Gerald Green    262
    ## 111         Gerald Henderson    662
    ## 112    Giannis Antetokounmpo   1832
    ## 113             Gorgui Dieng    816
    ## 114           Henry Ellenson     60
    ## 115                Ian Clark    527
    ## 116            Iman Shumpert    567
    ## 117            Isaiah Canaan    181
    ## 118            Isaiah Taylor      3
    ## 119            Isaiah Thomas   2199
    ## 120         Isaiah Whitehead    543
    ## 121                Ish Smith    758
    ## 122              Ivica Zubac    284
    ## 123               J.J. Barea    381
    ## 124              J.J. Redick   1173
    ## 125           JaMychal Green    689
    ## 126             JaVale McGee    472
    ## 127            Jabari Parker   1025
    ## 128              Jae Crowder    999
    ## 129            Jahlil Okafor    590
    ## 130              Jake Layman     78
    ## 131             Jakob Poeltl    165
    ## 132             Jamal Murray    811
    ## 133            Jameer Nelson    687
    ## 134              James Ennis    429
    ## 135            James Johnson    975
    ## 136              James Jones    132
    ## 137     James Michael McAdoo    147
    ## 138              James Young     68
    ## 139            Jarell Martin    165
    ## 140            Jarrod Uthoff     40
    ## 141              Jason Smith    420
    ## 142              Jason Terry    307
    ## 143             Jaylen Brown    515
    ## 144              Jeff Teague   1254
    ## 145              Jeff Withey    146
    ## 146             Jerami Grant    421
    ## 147              Jeremy Lamb    603
    ## 148             Jerian Grant    370
    ## 149           Jerryd Bayless     33
    ## 150              Jodie Meeks    327
    ## 151               Joe Harris    428
    ## 152               Joe Ingles    581
    ## 153                Joe Young     68
    ## 154             Joel Anthony     25
    ## 155            Joel Bolomboy     22
    ## 156              Joel Embiid    627
    ## 157        Joffrey Lauvergne     89
    ## 158          Johnny O'Bryant     18
    ## 159            Jonas Jerebko    299
    ## 160         Jonathon Simmons    483
    ## 161          Jordan Crawford    267
    ## 162              Jordan Hill     12
    ## 163            Jordan Mickey     38
    ## 164            Jose Calderon     61
    ## 165             Josh Huestis     14
    ## 166           Josh McRoberts    107
    ## 167          Josh Richardson    539
    ## 168         Juan Hernangomez    305
    ## 169            Julius Randle    975
    ## 170          Justin Anderson    203
    ## 171          Justin Hamilton    442
    ## 172           Justin Holiday    629
    ## 173          Justise Winslow    196
    ## 174             Jusuf Nurkic    304
    ## 175           K.J. McDaniels    126
    ## 176       Karl-Anthony Towns   2061
    ## 177               Kay Felder    166
    ## 178             Kelly Olynyk    678
    ## 179 Kentavious Caldwell-Pope   1047
    ## 180           Kevin Seraphin    232
    ## 181             Kevon Looney    135
    ## 182             Kosta Koufos    470
    ## 183                Kris Dunn    293
    ## 184           Kris Humphries    257
    ## 185       Kristaps Porzingis   1196
    ## 186            Kyle Anderson    246
    ## 187              Kyle Korver    373
    ## 188             Kyle O'Quinn    496
    ## 189             Kyle Singler     88
    ## 190             Kyle Wiltjer     13
    ## 191         Lance Stephenson     43
    ## 192             Lance Thomas    275
    ## 193        Langston Galloway    114
    ## 194          Larry Nance Jr.    449
    ## 195              Lavoy Allen    177
    ## 196          Leandro Barbosa    419
    ## 197             Lou Williams    343
    ## 198         Luc Mbah a Moute    484
    ## 199           Lucas Nogueira    253
    ## 200             Luke Babbitt    324
    ## 201       Malachi Richardson     79
    ## 202          Malcolm Brogdon    767
    ## 203          Malcolm Delaney    391
    ## 204            Malik Beasley     83
    ## 205          Marco Belinelli    780
    ## 206      Marcus Georges-Hunt     14
    ## 207            Marcus Morris   1105
    ## 208             Marcus Smart    835
    ## 209            Mario Hezonja    317
    ## 210          Markieff Morris   1063
    ## 211          Marquese Chriss    753
    ## 212        Marreese Speights    711
    ## 213         Marshall Plumlee     40
    ## 214            Mason Plumlee    245
    ## 215              Matt Barnes    114
    ## 216      Matthew Dellavedova    577
    ## 217         Maurice Harkless    773
    ## 218            Maurice Ndour     98
    ## 219        Metta World Peace     57
    ## 220           Meyers Leonard    401
    ## 221          Michael Beasley    528
    ## 222  Michael Carter-Williams    297
    ## 223          Michael Gbinije      4
    ## 224            Mike Dunleavy    169
    ## 225              Mike Miller     28
    ## 226             Mike Muscala    435
    ## 227     Mindaugas Kuzminskas    425
    ## 228         Montrezl Harrell    527
    ## 229             Myles Turner   1173
    ## 230          Nemanja Bjelica    403
    ## 231             Nerlens Noel    188
    ## 232            Nick Collison     33
    ## 233               Nick Young    791
    ## 234         Nicolas Brussino    150
    ## 235             Nik Stauskas    756
    ## 236             Nikola Jokic   1221
    ## 237           Nikola Mirotic    744
    ## 238              Noah Vonleh    327
    ## 239            Norman Powell    636
    ## 240              Norris Cole     43
    ## 241              Okaro White     98
    ## 242                Omer Asik     85
    ## 243              Omri Casspi     45
    ## 244              Otto Porter   1075
    ## 245              P.J. Tucker    139
    ## 246            Pascal Siakam    229
    ## 247          Pat Connaughton     98
    ## 248          Patricio Garino      0
    ## 249         Patrick Beverley    639
    ## 250            Patrick McCaw    282
    ## 251        Patrick Patterson    445
    ## 252              Patty Mills    759
    ## 253              Paul Pierce     81
    ## 254              Paul Zipser    240
    ## 255               Quincy Acy    209
    ## 256               Quinn Cook     52
    ## 257         Rakeem Christmas     59
    ## 258           Ramon Sessions    312
    ## 259               Randy Foye    357
    ## 260            Rashad Vaughn    142
    ## 261                Raul Neto    100
    ## 262           Raymond Felton    538
    ## 263           Reggie Bullock    141
    ## 264        Richard Jefferson    448
    ## 265           Richaun Holmes    559
    ## 266         Robert Covington    864
    ## 267              Rodney Hood    748
    ## 268          Rodney McGruder    497
    ## 269                Ron Baker    215
    ## 270  Rondae Hollis-Jefferson    675
    ## 271             Ronnie Price     14
    ## 272              Roy Hibbert      4
    ## 273              Rudy Gobert   1137
    ## 274               Ryan Kelly     25
    ## 275              Salah Mejri    213
    ## 276               Sam Dekker    504
    ## 277            Sasha Vujacic    124
    ## 278          Sean Kilpatrick    919
    ## 279           Semaj Christon    183
    ## 280         Sergio Rodriguez    530
    ## 281               Seth Curry    898
    ## 282         Shabazz Muhammad    772
    ## 283           Shabazz Napier    218
    ## 284         Shaun Livingston    389
    ## 285               Shawn Long    148
    ## 286        Sheldon McClellan     90
    ## 287             Shelvin Mack    430
    ## 288          Skal Labissiere    289
    ## 289        Spencer Dinwiddie    432
    ## 290            Spencer Hawes     83
    ## 291          Stanley Johnson    339
    ## 292        Stephen Zimmerman     23
    ## 293             Steven Adams    905
    ## 294           T.J. McConnell    556
    ## 295              T.J. Warren    951
    ## 296               Taj Gibson    207
    ## 297              Tarik Black    383
    ## 298            Terrence Ross    299
    ## 299             Terry Rozier    410
    ## 300          Thabo Sefolosha    444
    ## 301          Thomas Robinson    241
    ## 302               Thon Maker    226
    ## 303           Tiago Splitter     39
    ## 304              Tim Frazier    464
    ## 305             Tim Hardaway   1143
    ## 306           Tim Quarterman     31
    ## 307  Timothe Luwawu-Cabarrot    445
    ## 308         Tomas Satoransky    154
    ## 309               Tony Allen    643
    ## 310               Tony Snell    683
    ## 311           Treveon Graham     57
    ## 312             Trevor Ariza    936
    ## 313            Trevor Booker    709
    ## 314               Trey Burke    285
    ## 315               Trey Lyles    440
    ## 316             Troy Daniels    551
    ## 317            Troy Williams     58
    ## 318                Ty Lawson    681
    ## 319              Tyler Ennis    170
    ## 320            Tyler Johnson   1002
    ## 321               Tyler Ulis    444
    ## 322             Tyler Zeller    178
    ## 323               Tyus Jones    209
    ## 324            Udonis Haslem     31
    ## 325           Victor Oladipo   1067
    ## 326             Vince Carter    586
    ## 327             Wade Baldwin    106
    ## 328          Wayne Ellington    648
    ## 329             Wayne Selden     55
    ## 330           Wesley Johnson    186
    ## 331              Will Barton    820
    ## 332      Willie Cauley-Stein    611
    ## 333              Willie Reed    374
    ## 334        Willy Hernangomez    587
    ## 335             Yogi Ferrell    408
    ## 336              Zach LaVine    889
    ## 337            Zaza Pachulia    426

The intersection and except commands can be very integral parts of any data manipulation. With this being said, for more information about how these elements work utilize <https://nishanthu.github.io/articles/SQLSetandJoin.html> to learn more.

Take Home Message: Anyone that has utilized the SQL language in previous courses or through work experience, the sqldf function allows one to utilize these already gained skills but via the R language. This would allow one to best understand the differences between the languages and thus allow for the maximum results.

References: <https://www.r-bloggers.com/make-r-speak-sql-with-sqldf/> <https://www.youtube.com/watch?v=9JRsHxKCvsg> <http://blog.yhat.com/posts/10-R-packages-I-wish-I-knew-about-earlier.html> - where I found out about this syntax <https://www.r-bloggers.com/manipulating-data-frames-using-sqldf-a-brief-overview/> <http://analyticsplaybook.org/api/learn_sql_30_minutes.html> <https://nishanthu.github.io/articles/SQLSetandJoin.html> <https://cran.r-project.org/web/packages/sqldf/index.html>
