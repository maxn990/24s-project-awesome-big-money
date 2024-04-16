CREATE DATABASE IF NOT EXISTS LocalLeagueLegends;

USE LocalLeagueLegends;

CREATE TABLE IF NOT EXISTS Managers
(
    manager_id INTEGER AUTO_INCREMENT,
    firstName  VARCHAR(40)  NOT NULL,
    lastName   VARCHAR(40)  NOT NULL,
    email      VARCHAR(100) NOT NULL,
    phone      VARCHAR(15)  NOT NULL,
    address    VARCHAR(100) NOT NULL,
    PRIMARY KEY (manager_id)
);

CREATE TABLE IF NOT EXISTS Leagues
(
    league_id  INTEGER AUTO_INCREMENT,
    sportType  VARCHAR(40) NOT NULL,
    name       VARCHAR(40) NOT NULL,
    manager_id INTEGER     NOT NULL,
    PRIMARY KEY (league_id),
    CONSTRAINT fk_01
        FOREIGN KEY (manager_id) REFERENCES Managers (manager_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS Teams
(
    team_id   INTEGER AUTO_INCREMENT,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    season    VARCHAR(7)         NOT NULL, # Q<quarter number>-<Year>
    teamName  VARCHAR(40) UNIQUE NOT NULL,
    league_id INTEGER            NOT NULL,
    wins      INTEGER  DEFAULT 0,
    losses    INTEGER  DEFAULT 0,
    PRIMARY KEY (team_id),
    CONSTRAINT fk_02
        FOREIGN KEY (league_id) REFERENCES Leagues (league_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS Players
(
    player_id INTEGER AUTO_INCREMENT,
    lastName  VARCHAR(40)  NOT NULL,
    firstName VARCHAR(40)  NOT NULL,
    email     VARCHAR(40)  NOT NULL,
    address   VARCHAR(100) NOT NULL,
    phone     VARCHAR(15)  NOT NULL,
    PRIMARY KEY (player_id)
);

CREATE TABLE IF NOT EXISTS PlayerProfile
(
    sport     VARCHAR(40) DEFAULT 0,
    player_id INTEGER NOT NULL,
    fouls     INTEGER     DEFAULT 0,
    assists   INTEGER     DEFAULT 0,
    points    INTEGER     DEFAULT 0,
    PRIMARY KEY (player_id, sport),
    CONSTRAINT fk_03
        FOREIGN KEY (player_id) REFERENCES Players (player_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS PlayerTeams
(
    player_id INTEGER NOT NULL,
    team_id   INTEGER NOT NULL,
    PRIMARY KEY (player_id, team_id),
    CONSTRAINT fk_04
        FOREIGN KEY (player_id) REFERENCES Players (player_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_05
        FOREIGN KEY (team_id) REFERENCES Teams (team_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS TeamProfile
(
    sport   VARCHAR(40),
    team_id INTEGER,
    points  INTEGER DEFAULT 0,
    assists INTEGER DEFAULT 0,
    fouls   INTEGER DEFAULT 0,
    PRIMARY KEY (sport, team_id),
    CONSTRAINT fk_06
        FOREIGN KEY (team_id) REFERENCES Teams (team_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS Fans
(
    fan_id    INTEGER AUTO_INCREMENT,
    firstName VARCHAR(40)  NOT NULL,
    lastName  VARCHAR(40)  NOT NULL,
    address   VARCHAR(100) NOT NULL,
    phone     VARCHAR(15)  NOT NULL,
    email     VARCHAR(40)  NOT NULL,
    PRIMARY KEY (fan_id)

);

CREATE TABLE IF NOT EXISTS LeagueFans
(
    league_id integer NOT NULL,
    fan_id    integer NOT NULL,
    PRIMARY KEY (league_id, fan_id),
    CONSTRAINT fk_07
        FOREIGN KEY (league_id) REFERENCES Leagues (league_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_08
        FOREIGN KEY (fan_id) REFERENCES Fans (fan_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS FriendList
(
    fan_id    INTEGER,
    friend_id INTEGER,
    dateAdded DATE NOT NULL,
    PRIMARY KEY (fan_id, friend_id),
    CONSTRAINT fk_09
        FOREIGN KEY (fan_id) REFERENCES Fans (fan_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_10
        FOREIGN KEY (friend_id) REFERENCES Fans (fan_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS Coaches
(
    coach_id  INTEGER AUTO_INCREMENT,
    firstName VARCHAR(40)  NOT NULL,
    lastName  VARCHAR(40)  NOT NULL,
    email     VARCHAR(40)  NOT NULL,
    phone     VARCHAR(15)  NOT NULL,
    address   VARCHAR(100) NOT NULL,
    team_id   INTEGER,
    PRIMARY KEY (coach_id),
    CONSTRAINT fk_11
        FOREIGN KEY (team_id) REFERENCES Teams (team_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS Games
(
    game_id   INTEGER AUTO_INCREMENT,
    date      DATE        NOT NULL,
    winner_id INTEGER,
    time      TIME        NOT NULL,
    loser_id  INTEGER,
    referee   VARCHAR(80) NOT NULL,
    state     VARCHAR(2)  NOT NULL,
    city      VARCHAR(40) NOT NULL,
    park      VARCHAR(40) NOT NULL,
    PRIMARY KEY (game_id),
    CONSTRAINT fk_12
        FOREIGN KEY (winner_id) REFERENCES Teams (team_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_13
        FOREIGN KEY (loser_id) REFERENCES Teams (team_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS GameCoaches
(
    coach_id INTEGER,
    game_id  INTEGER,
    PRIMARY KEY (coach_id, game_id),
    CONSTRAINT fk_14
        FOREIGN KEY (coach_id) REFERENCES Coaches (coach_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_15
        FOREIGN KEY (game_id) REFERENCES Games (game_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS PlayerStats
(
    player_id INTEGER,
    game_id   INTEGER,
    points    INTEGER DEFAULT 0,
    assists   INTEGER DEFAULT 0,
    fouls     INTEGER DEFAULT 0,
    PRIMARY KEY (player_id, game_id),
    CONSTRAINT fk_16
        FOREIGN KEY (player_id) REFERENCES Players (player_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_17
        FOREIGN KEY (game_id) REFERENCES Games (game_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS TeamStats
(
    team_id INTEGER,
    game_id INTEGER,
    fouls   INTEGER DEFAULT 0,
    assists INTEGER DEFAULT 0,
    points  INTEGER DEFAULT 0,
    PRIMARY KEY (team_id, game_id),
    CONSTRAINT fk_18
        FOREIGN KEY (team_id) REFERENCES Teams (team_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_19
        FOREIGN KEY (game_id) REFERENCES Games (game_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS GameAttendance
(
    game_id   INTEGER,
    player_id INTEGER,
    PRIMARY KEY (game_id, player_id),
    CONSTRAINT fk_20
        FOREIGN KEY (game_id) REFERENCES Games (game_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_21
        FOREIGN KEY (player_id) REFERENCES Players (player_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS Practices
(
    practice_id INTEGER AUTO_INCREMENT,
    time        TIME        NOT NULL,
    date        DATE        NOT NULL,
    state       VARCHAR(2)  NOT NULL,
    city        VARCHAR(40) NOT NULL,
    park        VARCHAR(40) NOT NULL,
    PRIMARY KEY (practice_id)
);

CREATE TABLE IF NOT EXISTS PracticeAttendance
(
    practice_id INTEGER,
    player_id   INTEGER,
    PRIMARY KEY (practice_id, player_id),
    CONSTRAINT fk_22
        FOREIGN KEY (practice_id) REFERENCES Practices (practice_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_23
        FOREIGN KEY (player_id) REFERENCES Players (player_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS TeamGames
(
    team_id INTEGER,
    game_id INTEGER,
    PRIMARY KEY (team_id, game_id),
    CONSTRAINT fk_24
        FOREIGN KEY (team_id) REFERENCES Teams (team_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_25
        FOREIGN KEY (game_id) REFERENCES Games (game_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS TeamPractices
(
    practice_id INTEGER,
    team_id     INTEGER,
    PRIMARY KEY (practice_id, team_id),
    CONSTRAINT fk_26
        FOREIGN KEY (practice_id) REFERENCES Practices (practice_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_27
        FOREIGN KEY (team_id) REFERENCES Teams (team_id)
            ON UPDATE cascade ON DELETE restrict
);


insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (1, 'Sukey', 'Gravenell', 'sgravenell0@webnode.com', '801-234-2069', '7 Morning Park');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (2, 'Inga', 'Durn', 'idurn1@alibaba.com', '446-303-1627', '76798 Alpine Way');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (3, 'Padraic', 'Gritskov', 'pgritskov2@zdnet.com', '353-758-0103', '1246 Cherokee Way');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (4, 'Norma', 'Delouch', 'ndelouch3@msn.com', '449-488-7667', '1 Erie Center');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (5, 'Liza', 'Boykett', 'lboykett4@joomla.org', '182-531-8144', '696 Mockingbird Parkway');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (6, 'Hollyanne', 'Heersema', 'hheersema5@prnewswire.com', '948-693-3295', '9505 Sachs Point');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (7, 'Florette', 'Whitby', 'fwhitby6@google.nl', '207-758-3349', '95 Merry Road');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (8, 'Ronda', 'Newham', 'rnewham7@rambler.ru', '199-771-5218', '84424 Dennis Lane');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (9, 'Kelsi', 'Ygou', 'kygou8@pbs.org', '279-294-1497', '8 Arrowood Lane');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (10, 'Stanfield', 'Ottam', 'sottam9@va.gov', '720-342-5108', '7541 Gulseth Terrace');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (11, 'Nichol', 'Ion', 'niona@acquirethisname.com', '504-202-5011', '82679 Hollow Ridge Avenue');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (12, 'Aldin', 'Summerill', 'asummerillb@hc360.com', '537-909-3208', '8748 Weeping Birch Alley');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (13, 'Cleo', 'Mabone', 'cmabonec@discuz.net', '800-553-8385', '2477 Westport Pass');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (14, 'Decca', 'Guidelli', 'dguidellid@earthlink.net', '241-943-1962', '75 Ohio Crossing');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (15, 'Eyde', 'Shorey', 'eshoreye@imageshack.us', '736-958-1112', '6289 Merry Center');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (16, 'Jeff', 'Methven', 'jmethvenf@drupal.org', '132-856-9315', '0558 Londonderry Crossing');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (17, 'Florence', 'Monelli', 'fmonellig@rambler.ru', '193-450-8221', '525 Canary Hill');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (18, 'Noland', 'Mower', 'nmowerh@tuttocitta.it', '746-717-3342', '16622 Atwood Court');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (19, 'Cher', 'Leglise', 'cleglisei@de.vu', '977-701-1135', '61 Paget Street');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (20, 'Demott', 'Doudney', 'ddoudneyj@ifeng.com', '568-793-4572', '3 Lakeland Point');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (21, 'Krystyna', 'Fibben', 'kfibbenk@blogtalkradio.com', '947-463-3984', '16388 Huxley Street');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (22, 'Gery', 'Forrest', 'gforrestl@marketwatch.com', '551-452-1155', '5 Montana Crossing');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (23, 'Gerrie', 'Kuhl', 'gkuhlm@ftc.gov', '653-962-1350', '77528 Monica Terrace');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (24, 'Drucy', 'Lock', 'dlockn@w3.org', '695-278-1211', '308 Ludington Place');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (25, 'Lodovico', 'Lindroos', 'llindrooso@wsj.com', '554-486-5548', '50 Lighthouse Bay Crossing');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (26, 'Lanae', 'Yushin', 'lyushinp@last.fm', '342-405-1534', '1 Novick Avenue');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (27, 'Grethel', 'McCurt', 'gmccurtq@sphinn.com', '404-763-4114', '14 Gulseth Parkway');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (28, 'Emmet', 'Alltimes', 'ealltimesr@reuters.com', '841-626-9994', '7608 Fair Oaks Road');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (29, 'Chilton', 'Weald', 'cwealds@irs.gov', '980-908-8522', '412 Raven Lane');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (30, 'Axe', 'Roset', 'arosett@paginegialle.it', '823-976-2582', '86 Browning Avenue');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (31, 'Corissa', 'Feckey', 'cfeckeyu@seesaa.net', '607-728-6537', '28 Surrey Park');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (32, 'Kiele', 'Surcomb', 'ksurcombv@hubpages.com', '887-297-9031', '95527 Glacier Hill Point');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (33, 'Morissa', 'Mulloch', 'mmullochw@multiply.com', '902-213-3826', '11 Anhalt Crossing');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (34, 'Evangelia', 'Dougliss', 'edouglissx@elpais.com', '594-643-2129', '9509 Bartelt Center');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (35, 'Reinold', 'Tweedlie', 'rtweedliey@umich.edu', '134-614-3281', '408 Vernon Crossing');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (36, 'Cletus', 'Pech', 'cpechz@cbslocal.com', '560-640-2632', '525 Laurel Pass');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (37, 'Stinky', 'Dresser', 'sdresser10@washingtonpost.com', '134-343-6262', '46651 Lerdahl Center');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (38, 'Rubi', 'Dafydd', 'rdafydd11@wsj.com', '391-567-9557', '0444 Hagan Point');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (39, 'Laural', 'Newstead', 'lnewstead12@blinklist.com', '550-651-5361', '69449 Shoshone Crossing');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (40, 'Tilly', 'Sandyfirth', 'tsandyfirth13@unc.edu', '269-133-0305', '94 North Center');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (41, 'Kania', 'Halifax', 'khalifax14@techcrunch.com', '582-358-9924', '74269 Mcbride Avenue');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (42, 'Hillie', 'Venables', 'hvenables15@columbia.edu', '231-290-9696', '20 Columbus Terrace');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (43, 'Randell', 'Hanrahan', 'rhanrahan16@hatena.ne.jp', '533-999-3880', '24882 Maple Drive');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (44, 'Oran', 'Janaway', 'ojanaway17@cocolog-nifty.com', '983-734-0626', '81785 Nova Lane');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (45, 'Maurizia', 'Hadeke', 'mhadeke18@cdc.gov', '954-149-2391', '0 Eagle Crest Place');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (46, 'Karil', 'Ivetts', 'kivetts19@auda.org.au', '403-929-5918', '643 Di Loreto Terrace');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (47, 'Nev', 'Howkins', 'nhowkins1a@businesswire.com', '433-799-4316', '67607 Dawn Crossing');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (48, 'Roberta', 'Owenson', 'rowenson1b@china.com.cn', '682-471-8475', '80 Nobel Point');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (49, 'Andres', 'Pearse', 'apearse1c@1688.com', '431-975-1477', '88184 6th Pass');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (50, 'Fremont', 'Ethelston', 'fethelston1d@prweb.com', '218-839-5328', '104 Sauthoff Alley');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (51, 'Hobie', 'Chaimson', 'hchaimson1e@home.pl', '270-441-5306', '1628 Marquette Circle');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (52, 'Vyky', 'Keeping', 'vkeeping1f@ucoz.ru', '630-936-8195', '74878 Sommers Street');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (53, 'Sonya', 'Lambrecht', 'slambrecht1g@twitter.com', '277-330-4098', '9702 Lake View Court');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (54, 'Lurette', 'Chaffyn', 'lchaffyn1h@businesswire.com', '311-530-9757', '2373 Eliot Point');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (55, 'Northrop', 'Pegrum', 'npegrum1i@taobao.com', '114-754-3046', '634 Bunker Hill Parkway');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (56, 'Christal', 'Trow', 'ctrow1j@phoca.cz', '555-742-1694', '8014 Amoth Court');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (57, 'Nessa', 'Darbey', 'ndarbey1k@wix.com', '360-698-4438', '64 Pawling Trail');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (58, 'Janice', 'Swine', 'jswine1l@vinaora.com', '278-258-5601', '58009 8th Road');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (59, 'Tasha', 'McHaffy', 'tmchaffy1m@google.co.uk', '186-926-6102', '89452 Bluejay Center');
insert into Managers (manager_id, firstName, lastName, email, phone, address)
values (60, 'Hewe', 'Tyne', 'htyne1n@geocities.jp', '626-799-5787', '87570 3rd Parkway');

insert into Leagues (league_id, sportType, name, manager_id)
values (1, 'Field Hockey', 'Thunderbolts', 20);
insert into Leagues (league_id, sportType, name, manager_id)
values (2, 'Basketball', 'Raptors', 43);
insert into Leagues (league_id, sportType, name, manager_id)
values (3, 'Field Hockey', 'Tornadoes', 58);
insert into Leagues (league_id, sportType, name, manager_id)
values (4, 'Field Hockey', 'Dragons', 41);
insert into Leagues (league_id, sportType, name, manager_id)
values (5, 'American Football', 'Sharks', 12);
insert into Leagues (league_id, sportType, name, manager_id)
values (6, 'Hockey', 'Lions', 53);
insert into Leagues (league_id, sportType, name, manager_id)
values (7, 'Rugby', 'Tigers', 8);
insert into Leagues (league_id, sportType, name, manager_id)
values (8, 'Volleyball', 'Eagles', 21);
insert into Leagues (league_id, sportType, name, manager_id)
values (9, 'Water Polo', 'Wolves', 56);
insert into Leagues (league_id, sportType, name, manager_id)
values (10, 'Lacrosse', 'Panthers', 33);
insert into Leagues (league_id, sportType, name, manager_id)
values (11, 'Water Polo', 'Bears', 42);
insert into Leagues (league_id, sportType, name, manager_id)
values (12, 'Soccer', 'Cougars', 10);
insert into Leagues (league_id, sportType, name, manager_id)
values (13, 'Water Polo', 'Falcons', 31);
insert into Leagues (league_id, sportType, name, manager_id)
values (14, 'Handball', 'Hawks', 52);
insert into Leagues (league_id, sportType, name, manager_id)
values (15, 'Soccer', 'Cobras', 39);
insert into Leagues (league_id, sportType, name, manager_id)
values (16, 'Rugby', 'Scorpions', 59);
insert into Leagues (league_id, sportType, name, manager_id)
values (17, 'American Football', 'Vipers', 18);
insert into Leagues (league_id, sportType, name, manager_id)
values (18, 'Volleyball', 'Jaguars', 57);
insert into Leagues (league_id, sportType, name, manager_id)
values (19, 'Water Polo', 'Rhinos', 37);
insert into Leagues (league_id, sportType, name, manager_id)
values (20, 'Basketball', 'Bulldogs', 51);
insert into Leagues (league_id, sportType, name, manager_id)
values (21, 'Lacrosse', 'Wolverines', 35);
insert into Leagues (league_id, sportType, name, manager_id)
values (22, 'Soccer', 'Cheetahs', 54);
insert into Leagues (league_id, sportType, name, manager_id)
values (23, 'Rugby', 'Leopards', 5);
insert into Leagues (league_id, sportType, name, manager_id)
values (24, 'Soccer', 'Pumas', 9);
insert into Leagues (league_id, sportType, name, manager_id)
values (25, 'Handball', 'Stallions', 55);
insert into Leagues (league_id, sportType, name, manager_id)
values (26, 'Basketball', 'Mustangs', 50);
insert into Leagues (league_id, sportType, name, manager_id)
values (27, 'American Football', 'Colts', 13);
insert into Leagues (league_id, sportType, name, manager_id)
values (28, 'Basketball', 'Bisons', 30);
insert into Leagues (league_id, sportType, name, manager_id)
values (29, 'American Football', 'Buffaloes', 60);
insert into Leagues (league_id, sportType, name, manager_id)
values (30, 'Volleyball', 'Gators', 19);
insert into Leagues (league_id, sportType, name, manager_id)
values (31, 'Field Hockey', 'Crocodiles', 36);
insert into Leagues (league_id, sportType, name, manager_id)
values (32, 'Soccer', 'Piranhas', 32);
insert into Leagues (league_id, sportType, name, manager_id)
values (33, 'Volleyball', 'Stingrays', 27);
insert into Leagues (league_id, sportType, name, manager_id)
values (34, 'Field Hockey', 'Mantas', 38);
insert into Leagues (league_id, sportType, name, manager_id)
values (35, 'Hockey', 'Dolphins', 28);
insert into Leagues (league_id, sportType, name, manager_id)
values (36, 'Lacrosse', 'Orcas', 22);
insert into Leagues (league_id, sportType, name, manager_id)
values (37, 'Hockey', 'Penguins', 46);
insert into Leagues (league_id, sportType, name, manager_id)
values (38, 'Field Hockey', 'Seals', 14);
insert into Leagues (league_id, sportType, name, manager_id)
values (39, 'Basketball', 'Otters', 1);
insert into Leagues (league_id, sportType, name, manager_id)
values (40, 'Soccer', 'Beavers', 2);
insert into Leagues (league_id, sportType, name, manager_id)
values (41, 'Hockey', 'Sasquatches', 23);
insert into Leagues (league_id, sportType, name, manager_id)
values (42, 'American Football', 'Yetis', 29);
insert into Leagues (league_id, sportType, name, manager_id)
values (43, 'Hockey', 'Aliens', 3);
insert into Leagues (league_id, sportType, name, manager_id)
values (44, 'Field Hockey', 'Martians', 45);
insert into Leagues (league_id, sportType, name, manager_id)
values (45, 'Field Hockey', 'Astronauts', 11);
insert into Leagues (league_id, sportType, name, manager_id)
values (46, 'American Football', 'Comets', 47);
insert into Leagues (league_id, sportType, name, manager_id)
values (47, 'Water Polo', 'Galaxies', 40);
insert into Leagues (league_id, sportType, name, manager_id)
values (48, 'Water Polo', 'Nebulas', 17);
insert into Leagues (league_id, sportType, name, manager_id)
values (49, 'Volleyball', 'Supernovas', 15);
insert into Leagues (league_id, sportType, name, manager_id)
values (50, 'Soccer', 'Black Holes', 7);
insert into Leagues (league_id, sportType, name, manager_id)
values (51, 'Hockey', 'Asteroids', 26);
insert into Leagues (league_id, sportType, name, manager_id)
values (52, 'Water Polo', 'Meteorites', 6);
insert into Leagues (league_id, sportType, name, manager_id)
values (53, 'Volleyball', 'Satellites', 4);
insert into Leagues (league_id, sportType, name, manager_id)
values (54, 'Field Hockey', 'Spacewalkers', 34);
insert into Leagues (league_id, sportType, name, manager_id)
values (55, 'Lacrosse', 'Cosmonauts', 49);
insert into Leagues (league_id, sportType, name, manager_id)
values (56, 'Soccer', 'Astronomers', 48);
insert into Leagues (league_id, sportType, name, manager_id)
values (57, 'Basketball', 'Astrologers', 24);
insert into Leagues (league_id, sportType, name, manager_id)
values (58, 'Volleyball', 'Stargazers', 16);
insert into Leagues (league_id, sportType, name, manager_id)
values (59, 'Water Polo', 'Thunderbolts', 25);
insert into Leagues (league_id, sportType, name, manager_id)
values (60, 'Soccer', 'Raptors', 44);

insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (1, 'Lorant', 'Flye', 'lflye0@nih.gov', '972-498-1128', '45 Ridgeway Street');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (2, 'Brianne', 'Tite', 'btite1@nps.gov', '813-493-2833', '1023 Londonderry Avenue');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (3, 'Merry', 'Whetton', 'mwhetton2@reuters.com', '830-922-8359', '29446 Parkside Street');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (4, 'Jerrilyn', 'Varah', 'jvarah3@nydailynews.com', '324-222-4351', '884 Kenwood Circle');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (5, 'Jonell', 'Pehrsson', 'jpehrsson4@wikispaces.com', '117-407-9686', '85719 Summit Point');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (6, 'Elisabeth', 'Struss', 'estruss5@seattletimes.com', '214-124-9899', '2736 Doe Crossing Plaza');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (7, 'Odele', 'Snell', 'osnell6@hostgator.com', '958-523-5141', '451 Valley Edge Court');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (8, 'Scarface', 'Dan', 'sdan7@slashdot.org', '153-506-1966', '3042 Lillian Alley');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (9, 'Jorge', 'Duinbleton', 'jduinbleton8@oaic.gov.au', '677-915-9758', '2 Everett Center');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (10, 'Gun', 'Chaman', 'gchaman9@yellowbook.com', '342-939-3379', '47 Corben Alley');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (11, 'Xena', 'Lovering', 'xloveringa@vimeo.com', '474-319-3060', '6726 Del Sol Parkway');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (12, 'Alyda', 'Rolling', 'arollingb@mozilla.com', '192-773-1083', '651 Shelley Parkway');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (13, 'Magdalena', 'Bransom', 'mbransomc@nationalgeographic.com', '110-883-7097', '58 Fisk Place');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (14, 'Sawyere', 'Greenlies', 'sgreenliesd@howstuffworks.com', '764-524-2353', '93439 Little Fleur Point');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (15, 'Aloisia', 'Annies', 'aanniese@vk.com', '982-907-4885', '40447 Dawn Crossing');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (16, 'Alexi', 'Rainville', 'arainvillef@epa.gov', '545-703-4847', '754 Maple Wood Road');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (17, 'Jany', 'Kiln', 'jkilng@twitter.com', '351-679-2200', '04 Summer Ridge Plaza');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (18, 'Mattie', 'Scully', 'mscullyh@imageshack.us', '795-824-2892', '0 Bayside Terrace');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (19, 'Amargo', 'Pesik', 'apesiki@nymag.com', '677-647-1679', '5 Stuart Junction');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (20, 'Carolyn', 'Entreis', 'centreisj@telegraph.co.uk', '921-774-8076', '756 Arkansas Trail');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (21, 'Hanny', 'Zanassi', 'hzanassik@indiegogo.com', '119-941-7588', '249 Hansons Center');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (22, 'Rutledge', 'Fleeman', 'rfleemanl@imdb.com', '822-661-7300', '75018 8th Avenue');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (23, 'Marylynne', 'Kingsmill', 'mkingsmillm@icio.us', '752-294-0153', '0 Haas Terrace');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (24, 'Chiquia', 'Acreman', 'cacremann@devhub.com', '898-227-7770', '0 Hooker Street');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (25, 'Nefen', 'Cristou', 'ncristouo@wsj.com', '723-104-1171', '21420 Sutherland Junction');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (26, 'Carena', 'Fitter', 'cfitterp@tiny.cc', '367-637-5449', '6 American Trail');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (27, 'Ole', 'Antonowicz', 'oantonowiczq@cocolog-nifty.com', '899-386-0568', '6753 Anniversary Drive');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (28, 'Darsie', 'Pietz', 'dpietzr@macromedia.com', '381-124-6788', '05 Summit Junction');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (29, 'Francesca', 'Lerwell', 'flerwells@forbes.com', '348-943-8654', '80 Longview Crossing');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (30, 'Susanna', 'Orhtmann', 'sorhtmannt@thetimes.co.uk', '895-765-1171', '01493 Merrick Drive');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (31, 'Humfried', 'Frawley', 'hfrawleyu@home.pl', '337-370-2614', '73998 Huxley Trail');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (32, 'Cosmo', 'Middle', 'cmiddlev@altervista.org', '149-749-4811', '0 Dunning Court');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (33, 'Martie', 'Ault', 'maultw@omniture.com', '684-110-1217', '3 Stoughton Road');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (34, 'Wat', 'Redmain', 'wredmainx@spiegel.de', '139-200-9388', '79455 Fairview Park');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (35, 'Juliette', 'Daynter', 'jdayntery@discuz.net', '897-127-5265', '0 Mallory Trail');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (36, 'Barrie', 'Matzkaitis', 'bmatzkaitisz@symantec.com', '954-938-0835', '06562 Hanson Drive');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (37, 'Carlie', 'Bazek', 'cbazek10@arizona.edu', '252-122-3519', '9686 High Crossing Court');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (38, 'Orella', 'Pattie', 'opattie11@nature.com', '848-888-1002', '974 Texas Park');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (39, 'Griffy', 'Cicchinelli', 'gcicchinelli12@prweb.com', '742-623-3978', '143 Eagan Drive');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (40, 'Niccolo', 'Haffenden', 'nhaffenden13@youtu.be', '755-560-0425', '6 Maryland Way');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (41, 'Sara', 'Okker', 'sokker14@cnn.com', '898-899-3908', '37 Westridge Pass');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (42, 'Tito', 'Horbath', 'thorbath15@etsy.com', '543-976-7953', '1611 Gina Drive');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (43, 'Carroll', 'Oldale', 'coldale16@answers.com', '823-283-2278', '6188 Lakewood Junction');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (44, 'Nevil', 'Madden', 'nmadden17@blogspot.com', '196-693-0603', '92 Kipling Center');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (45, 'Joanie', 'Phil', 'jphil18@nbcnews.com', '295-652-9545', '555 Hansons Terrace');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (46, 'Robert', 'Stidston', 'rstidston19@businessinsider.com', '111-613-0888', '7 Menomonie Hill');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (47, 'Barb', 'Canaan', 'bcanaan1a@who.int', '251-917-8416', '1682 Northfield Road');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (48, 'Linus', 'Bunclark', 'lbunclark1b@geocities.jp', '865-939-6815', '4 Larry Parkway');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (49, 'Aguistin', 'Drejer', 'adrejer1c@t-online.de', '400-203-4714', '744 Burning Wood Parkway');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (50, 'Ileane', 'Seebright', 'iseebright1d@house.gov', '388-798-2683', '74 Acker Court');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (51, 'Jude', 'Whittet', 'jwhittet1e@csmonitor.com', '394-964-7166', '42 Westend Crossing');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (52, 'Graham', 'Bohje', 'gbohje1f@fc2.com', '755-820-7756', '674 Susan Trail');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (53, 'Gaylene', 'Elden', 'gelden1g@icq.com', '892-304-9045', '98 Golf Course Drive');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (54, 'Gaby', 'Lipsett', 'glipsett1h@intel.com', '259-273-9182', '88 Norway Maple Drive');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (55, 'Elfrieda', 'Lune', 'elune1i@whitehouse.gov', '522-132-5234', '6800 Hovde Lane');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (56, 'Lock', 'Preece', 'lpreece1j@yale.edu', '928-789-9862', '1 Trailsway Circle');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (57, 'Dev', 'Shinton', 'dshinton1k@slate.com', '277-721-2221', '17 Melby Pass');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (58, 'Aimee', 'Jiroudek', 'ajiroudek1l@google.com.au', '218-147-4214', '71369 Boyd Parkway');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (59, 'Trixy', 'Rowter', 'trowter1m@abc.net.au', '491-670-4258', '4 Twin Pines Center');
insert into Fans (fan_id, firstName, lastName, email, phone, address)
values (60, 'Thornton', 'Kitchaside', 'tkitchaside1n@google.nl', '498-836-3513', '9 Cottonwood Lane');

insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (1, 'Tiger Sharks', 'Q3-2026', 10, 13, '2023-06-04', 12);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (2, 'Thunderbolts', 'Q3-2024', 7, 9, '2024-02-25', 36);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (3, 'Golden Eagles', 'Q3-2028', 14, 1, '2023-07-09', 8);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (4, 'Fire Dragons', 'Q1-2027', 2, 13, '2024-04-06', 31);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (5, 'Silver Wolves', 'Q2-2026', 12, 3, '2023-07-26', 48);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (6, 'Sapphire Falcons', 'Q3-2026', 4, 7, '2023-12-24', 39);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (7, 'Emerald Knights', 'Q2-2024', 9, 12, '2023-09-07', 10);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (8, 'Crimson Lions', 'Q1-2026', 4, 11, '2023-10-24', 53);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (9, 'Midnight Panthers', 'Q3-2024', 7, 3, '2023-07-17', 19);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (10, 'Frost Giants', 'Q1-2027', 1, 9, '2023-07-19', 25);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (11, 'Sunset Dolphins', 'Q1-2027', 5, 6, '2023-06-03', 44);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (12, 'Mystic Unicorns', 'Q3-2024', 9, 1, '2023-08-31', 17);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (13, 'Shadow Hawks', 'Q1-2024', 4, 2, '2024-03-02', 60);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (14, 'Blazing Phoenix', 'Q3-2027', 2, 14, '2024-01-09', 42);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (15, 'Steel Titans', 'Q3-2028', 12, 13, '2023-12-27', 21);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (16, 'Ocean Warriors', 'Q1-2027', 8, 4, '2024-01-19', 14);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (17, 'Lunar Wolves', 'Q2-2027', 0, 5, '2023-09-26', 56);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (18, 'Vortex Vipers', 'Q4-2027', 5, 1, '2024-02-19', 11);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (19, 'Inferno Dragons', 'Q1-2024', 5, 15, '2023-10-27', 3);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (20, 'Aurora Bears', 'Q3-2027', 7, 11, '2024-02-01', 22);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (21, 'Galactic Guardians', 'Q1-2027', 12, 5, '2024-02-08', 6);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (22, 'Wild Mustangs', 'Q4-2028', 4, 3, '2023-10-12', 58);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (23, 'Electric Storm', 'Q2-2028', 12, 13, '2024-01-19', 38);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (24, 'Jungle Jaguars', 'Q1-2024', 2, 0, '2023-06-09', 24);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (25, 'Polar Bears', 'Q2-2027', 5, 10, '2023-08-10', 30);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (26, 'Moonlight Tigers', 'Q3-2026', 7, 4, '2023-06-25', 32);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (27, 'Neon Knights', 'Q4-2027', 4, 8, '2023-04-16', 13);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (28, 'Star Strikers', 'Q2-2026', 3, 6, '2023-10-02', 1);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (29, 'Crystal Cobras', 'Q1-2028', 8, 0, '2023-06-18', 26);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (30, 'Blizzard Hawks', 'Q3-2025', 1, 2, '2023-06-26', 43);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (31, 'Golden Griffins', 'Q4-2027', 1, 12, '2023-05-04', 4);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (32, 'Thunder Wolves', 'Q4-2025', 0, 12, '2023-12-20', 51);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (33, 'Sunrise Eagles', 'Q3-2024', 9, 6, '2023-07-28', 15);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (34, 'Midnight Ravens', 'Q2-2025', 12, 8, '2023-08-05', 9);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (35, 'Frostbite Falcons', 'Q3-2026', 11, 10, '2023-09-25', 18);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (36, 'Flame Phoenix', 'Q4-2024', 8, 5, '2023-05-21', 55);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (37, 'Iron Giants', 'Q2-2025', 13, 8, '2023-07-22', 59);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (38, 'Wave Riders', 'Q4-2025', 11, 4, '2023-09-24', 5);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (39, 'Twilight Tigers', 'Q2-2028', 5, 9, '2023-09-26', 41);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (40, 'Cosmic Comets', 'Q3-2025', 7, 5, '2023-08-15', 23);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (41, 'Majestic Lions', 'Q1-2027', 8, 8, '2023-06-02', 29);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (42, 'Nightfall Ninjas', 'Q1-2027', 4, 6, '2024-02-19', 35);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (43, 'Thunderstorm Titans', 'Q2-2027', 8, 0, '2023-09-13', 20);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (44, 'Aqua Sharks', 'Q1-2027', 9, 8, '2023-05-01', 52);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (45, 'Silver Streaks', 'Q3-2025', 0, 4, '2024-03-02', 50);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (46, 'Royal Ravens', 'Q2-2028', 14, 2, '2024-01-03', 37);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (47, 'Firestorm Falcons', 'Q2-2028', 12, 8, '2023-11-20', 46);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (48, 'Emerald Enforcers', 'Q1-2026', 13, 14, '2023-11-20', 27);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (49, 'Sapphire Sabers', 'Q2-2027', 7, 9, '2023-09-20', 34);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (50, 'Golden Gladiators', 'Q3-2026', 9, 8, '2023-09-11', 47);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (51, 'Crimson Crushers', 'Q4-2026', 5, 12, '2023-11-26', 57);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (52, 'Midnight Marauders', 'Q3-2027', 4, 6, '2024-02-26', 40);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (53, 'Frostbite Fury', 'Q3-2027', 4, 0, '2024-02-13', 2);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (54, 'Sunset Savages', 'Q3-2028', 11, 9, '2024-04-01', 54);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (55, 'Mystic Masters', 'Q4-2028', 4, 13, '2023-11-23', 16);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (56, 'Shadow Soldiers', 'Q4-2027', 10, 4, '2023-12-08', 33);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (57, 'Blazing Blades', 'Q4-2026', 3, 4, '2023-12-01', 49);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (58, 'Steel Sentinels', 'Q2-2027', 3, 2, '2023-04-25', 7);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (59, 'Ocean Outlaws', 'Q2-2027', 8, 3, '2023-04-18', 28);
insert into Teams (team_id, teamName, season, wins, losses, createdAt, league_id)
values (60, 'Lunar Legends', 'Q2-2027', 12, 15, '2023-08-19', 45);

insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (1, '2023-09-26', '22:31:08', 'Kakalina Winnett', 'AK', 'Silver Creek', 'Whispering Pines Park', 4, 37);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (2, '2023-08-02', '5:48:35', 'Kelsey Sanpere', 'MI', 'Maplewood', 'Cedar Ridge Park', 7, 28);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (3, '2023-08-14', '13:49:49', 'Meaghan Robus', 'MN', 'Springfield', 'Pinecrest Park', 27, 34);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (4, '2023-05-07', '20:45:36', 'Mychal Pieper', 'NV', 'Oakwood', 'Valley View Park', 5, 6);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (5, '2023-07-16', '1:40:18', 'Shellysheldon Cowing', 'NY', 'Lakeview', 'Golden Gate Park', 2, 20);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (6, '2024-03-31', '1:01:06', 'Teodorico Hawksworth', 'WA', 'Springfield', 'Mountain View Park', 47, 36);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (7, '2023-05-26', '3:38:31', 'Jessey Billanie', 'GA', 'Silver Creek', 'Maple Grove Park', 46, 49);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (8, '2023-04-16', '17:59:55', 'Marcelle Woods', 'OH', 'Hillcrest', 'Greenwood Park', 57, 12);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (9, '2023-07-19', '8:28:47', 'Hart Luc', 'MD', 'Mountain Ridge', 'Pinecrest Park', 58, 31);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (10, '2023-06-09', '21:00:59', 'Giffy Wigginton', 'WY', 'Hillcrest', 'Harbor Point Park', 35, 4);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (11, '2024-02-14', '15:02:01', 'Fernande Cathee', 'WY', 'Rivertown', 'Harbor Point Park', 45, 13);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (12, '2024-02-24', '9:24:02', 'Brandais Nancarrow', 'MO', 'Harbor City', 'Golden Gate Park', 32, 26);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (13, '2023-08-12', '16:03:58', 'Yvor Scrase', 'OH', 'Valley Heights', 'Wildflower Park', 25, 40);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (14, '2023-05-02', '11:02:37', 'Ingunna Blindmann', 'NJ', 'Hillcrest', 'Greenwood Park', 10, 35);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (15, '2024-03-11', '17:52:13', 'Karalynn Dotterill', 'VT', 'Hillcrest', 'Springfield Park', 48, 48);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (16, '2023-12-04', '15:27:28', 'Trip Pahler', 'GA', 'Valley Heights', 'Harbor Point Park', 12, 30);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (17, '2024-02-29', '12:16:54', 'Randene Lympany', 'VA', 'Valley Heights', 'Meadowview Park', 19, 51);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (18, '2023-05-08', '9:07:37', 'Austin Blackburne', 'AK', 'Pinecrest', 'Sunset Park', 1, 58);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (19, '2023-07-06', '3:41:28', 'Beniamino Belleny', 'IN', 'Sunset Springs', 'Riverside Park', 28, 47);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (20, '2023-11-04', '21:44:02', 'Abdel Vertigan', 'TX', 'Maplewood', 'Springfield Park', 50, 8);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (21, '2023-12-20', '12:14:31', 'Elianore Kleinstub', 'AZ', 'Rivertown', 'Sunset Park', 29, 53);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (22, '2024-03-02', '23:22:37', 'Jabez Lennie', 'DE', 'Willow Creek', 'Willow Creek Park', 8, 14);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (23, '2023-11-16', '5:06:03', 'Megen Goodwin', 'AL', 'Springfield', 'Sunnydale Park', 9, 43);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (24, '2023-09-08', '0:06:40', 'Vanni Duhig', 'ND', 'Meadowville', 'Whispering Pines Park', 34, 56);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (25, '2024-03-14', '2:35:46', 'Fanny Greated', 'CO', 'Rivertown', 'Greenwood Park', 30, 38);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (26, '2023-07-10', '19:26:07', 'Deny Mawford', 'AZ', 'Hillcrest', 'Golden Gate Park', 31, 5);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (27, '2023-12-29', '4:23:40', 'Lotte Iacobassi', 'HI', 'Meadowville', 'Wildflower Park', 21, 2);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (28, '2023-08-07', '14:39:21', 'Elberta Santello', 'MD', 'Valley Heights', 'Willow Creek Park', 22, 27);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (29, '2023-07-29', '5:18:56', 'Lazaro Thacker', 'WV', 'Willow Creek', 'Pinecrest Park', 39, 44);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (30, '2023-10-10', '2:26:29', 'Ardyce Risborough', 'MT', 'Meadowville', 'Oakwood Park', 6, 59);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (31, '2023-04-15', '3:26:39', 'Lynnet Campling', 'CA', 'Silver Creek', 'Oakwood Park', 55, 10);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (32, '2023-12-01', '19:26:22', 'Car Frankton', 'MN', 'Rivertown', 'Wildflower Park', 17, 60);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (33, '2023-11-07', '8:34:26', 'Abrahan Minci', 'MA', 'Riverdale', 'Oakwood Park', 3, 55);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (34, '2024-03-11', '22:45:38', 'Tanhya Ritmeier', 'NV', 'Silver Creek', 'Wildflower Park', 15, 16);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (35, '2023-12-24', '16:11:16', 'Eileen Seifenmacher', 'IN', 'Springfield', 'Whispering Pines Park', 59, 29);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (36, '2023-11-20', '11:21:36', 'Gladi Shapiro', 'NY', 'Golden Valley', 'Valley View Park', 52, 21);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (37, '2024-01-22', '11:10:59', 'Ibby Clapson', 'AL', 'Maplewood', 'Hillside Park', 51, 46);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (38, '2023-12-25', '6:12:37', 'Rivalee Helks', 'IN', 'Silver Creek', 'Sunnydale Park', 40, 45);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (39, '2023-10-21', '0:30:03', 'Neala Highman', 'NV', 'Maplewood', 'Oakwood Park', 14, 32);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (40, '2023-11-24', '1:37:55', 'Matilda Spawforth', 'IA', 'Silver Creek', 'Silver Lake Park', 49, 42);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (41, '2024-02-02', '17:32:23', 'Karlotte Rao', 'WI', 'Willow Creek', 'Sunset Park', 33, 9);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (42, '2023-05-31', '16:01:53', 'Gabrielle Yewen', 'WI', 'Meadowville', 'Wildflower Park', 36, 52);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (43, '2024-01-02', '20:16:53', 'Doralin Tankard', 'AZ', 'Springfield', 'Valley View Park', 60, 24);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (44, '2023-04-18', '3:09:17', 'Erica Norker', 'WV', 'Golden Valley', 'Sunset Park', 53, 33);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (45, '2023-06-01', '3:11:49', 'Sharron Spivie', 'IL', 'Springfield', 'Greenwood Park', 38, 23);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (46, '2024-02-08', '5:53:41', 'Gussie Rides', 'CT', 'Harbor City', 'Golden Gate Park', 20, 3);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (47, '2023-07-03', '9:32:51', 'Niel Eberts', 'OR', 'Lakeview', 'Maple Grove Park', 26, 25);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (48, '2023-11-02', '18:07:54', 'Zaccaria Capstaff', 'AK', 'Oceanview', 'Harbor Point Park', 54, 22);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (49, '2023-09-23', '9:04:42', 'Krissy Pawlicki', 'NV', 'Springfield', 'Sunset Park', 24, 17);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (50, '2023-07-03', '6:24:25', 'Reuben Unwin', 'VA', 'Mountain Ridge', 'Whispering Pines Park', 18, 19);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (51, '2023-06-23', '15:33:25', 'Concettina McSparran', 'AZ', 'Springfield', 'Willow Creek Park', 11, 57);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (52, '2024-03-29', '23:34:13', 'Abigael Bayfield', 'CO', 'Oceanview', 'Sunset Park', 23, 1);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (53, '2023-11-06', '14:29:58', 'Bowie Recher', 'MS', 'Oakwood', 'Lakeside Park', 56, 50);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (54, '2024-01-23', '17:44:17', 'Lurleen Swanston', 'ID', 'Golden Valley', 'Springfield Park', 43, 54);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (55, '2023-11-24', '4:51:05', 'Chanda Janiak', 'MA', 'Prairieville', 'Golden Gate Park', 41, 41);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (56, '2023-06-26', '12:31:44', 'Maxwell Waskett', 'PA', 'Prairieville', 'Hillside Park', 13, 18);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (57, '2023-08-20', '17:44:45', 'Claire Vossing', 'PA', 'Valley Heights', 'Springfield Park', 42, 15);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (58, '2024-03-15', '9:34:38', 'Glyn Smellie', 'MI', 'Maplewood', 'Greenwood Park', 44, 7);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (59, '2024-03-08', '8:12:09', 'Davita Ganing', 'WI', 'Riverdale', 'Springfield Park', 16, 39);
insert into Games (game_id, date, time, referee, state, city, park, winner_id, loser_id)
values (60, '2023-07-27', '12:17:01', 'Hillier Gifford', 'RI', 'Golden Valley', 'Mountain View Park', 37, 11);

insert into Players (player_id, firstName, lastName, email, phone, address)
values (1, 'Sloan', 'Ather', 'sather0@pinterest.com', '415-981-0646', '92 Ridgeview Point');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (2, 'Shina', 'Batter', 'sbatter1@google.it', '876-519-4277', '9919 Cody Street');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (3, 'Cheston', 'Eley', 'celey2@stumbleupon.com', '956-594-5903', '700 Grasskamp Center');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (4, 'Loren', 'Crampton', 'lcrampton3@freewebs.com', '917-502-2230', '07723 Fordem Junction');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (5, 'Davey', 'Bagnell', 'dbagnell4@jimdo.com', '194-718-1515', '8236 Dovetail Center');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (6, 'Graham', 'O''Rafferty', 'gorafferty5@shareasale.com', '144-578-0492', '16548 Northport Drive');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (7, 'Madella', 'Yeude', 'myeude6@forbes.com', '785-198-0764', '940 Cascade Road');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (8, 'Konrad', 'Jorioz', 'kjorioz7@amazon.com', '695-484-6202', '854 Schlimgen Park');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (9, 'Alain', 'Kitcatt', 'akitcatt8@friendfeed.com', '246-384-3249', '5040 Northwestern Court');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (10, 'Kendrick', 'Kupka', 'kkupka9@networksolutions.com', '205-767-1475', '6998 Rutledge Drive');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (11, 'Lauren', 'Scobie', 'lscobiea@1688.com', '431-777-0071', '4 Emmet Point');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (12, 'Jeromy', 'Hancell', 'jhancellb@zdnet.com', '136-191-4560', '05901 Eliot Lane');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (13, 'Kaylee', 'Meenehan', 'kmeenehanc@parallels.com', '583-319-2543', '5020 Fallview Park');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (14, 'Roosevelt', 'Ogbourne', 'rogbourned@businessweek.com', '635-741-0821', '222 Hoard Avenue');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (15, 'Zsazsa', 'De Mitris', 'zdemitrise@goo.ne.jp', '587-261-4349', '65 Luster Pass');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (16, 'Justine', 'Possa', 'jpossaf@engadget.com', '261-442-8683', '2 Westport Point');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (17, 'Tedman', 'Guerreau', 'tguerreaug@ask.com', '837-414-5070', '73796 Fair Oaks Terrace');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (18, 'Maurene', 'Belfitt', 'mbelfitth@gizmodo.com', '658-236-1721', '9822 Scott Plaza');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (19, 'Horacio', 'Hunte', 'hhuntei@mail.ru', '202-993-7308', '6101 Nancy Lane');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (20, 'Ingmar', 'Sacker', 'isackerj@cbslocal.com', '789-113-1650', '01 Ronald Regan Way');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (21, 'Mattie', 'Howgate', 'mhowgatek@google.com.hk', '783-344-7977', '83 Merrick Way');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (22, 'Hadley', 'Schwanden', 'hschwandenl@topsy.com', '552-759-3924', '7688 Haas Center');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (23, 'Natassia', 'Conry', 'nconrym@mlb.com', '527-557-0603', '99 Paget Alley');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (24, 'Vin', 'Wardesworth', 'vwardesworthn@cocolog-nifty.com', '942-605-0086', '617 Vernon Point');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (25, 'Frayda', 'Seint', 'fseinto@addtoany.com', '553-843-3459', '945 Doe Crossing Pass');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (26, 'Henderson', 'Hampson', 'hhampsonp@marriott.com', '782-792-8647', '0747 Darwin Plaza');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (27, 'Adey', 'Moxham', 'amoxhamq@ucla.edu', '912-606-3696', '5 Florence Circle');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (28, 'Guenna', 'Durber', 'gdurberr@slate.com', '230-925-7985', '49 8th Hill');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (29, 'Hervey', 'Matiebe', 'hmatiebes@simplemachines.org', '606-974-4618', '171 Chinook Road');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (30, 'Krystyna', 'Carne', 'kcarnet@acquirethisname.com', '325-365-1051', '28094 Trailsway Crossing');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (31, 'Missie', 'Elson', 'melsonu@china.com.cn', '581-829-0575', '77 Susan Terrace');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (32, 'Katie', 'Theobalds', 'ktheobaldsv@amazon.co.jp', '586-577-6633', '38849 Sundown Drive');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (33, 'Susanetta', 'Warnes', 'swarnesw@clickbank.net', '519-368-8559', '43 Dunning Drive');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (34, 'Roxi', 'Rushmer', 'rrushmerx@prlog.org', '881-596-3866', '0 Carpenter Court');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (35, 'Jamie', 'Fynes', 'jfynesy@wunderground.com', '692-104-9517', '956 Manufacturers Court');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (36, 'Elena', 'Atthow', 'eatthowz@simplemachines.org', '960-488-7918', '5 Milwaukee Point');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (37, 'Aile', 'Martignoni', 'amartignoni10@phpbb.com', '781-396-9778', '5912 Cottonwood Point');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (38, 'Nyssa', 'Lurcock', 'nlurcock11@csmonitor.com', '381-624-6669', '448 Novick Trail');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (39, 'Hillier', 'Towne', 'htowne12@sciencedirect.com', '336-688-6268', '416 Artisan Junction');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (40, 'Sarena', 'Morphew', 'smorphew13@un.org', '181-915-4117', '451 Corry Plaza');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (41, 'Julissa', 'Rudwell', 'jrudwell14@themeforest.net', '278-960-0335', '46 Vermont Point');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (42, 'Mahmud', 'Luxmoore', 'mluxmoore15@dion.ne.jp', '893-367-8145', '36086 Oak Valley Trail');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (43, 'Devland', 'Gravenor', 'dgravenor16@reference.com', '577-523-5418', '7 Mendota Trail');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (44, 'Gwenny', 'Perkis', 'gperkis17@shutterfly.com', '829-378-0346', '6 Granby Way');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (45, 'Natalee', 'Peacock', 'npeacock18@xinhuanet.com', '983-237-2806', '7 Dapin Junction');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (46, 'Lucias', 'Dran', 'ldran19@bbb.org', '372-742-4461', '704 Pierstorff Way');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (47, 'Hedwiga', 'Jellyman', 'hjellyman1a@networksolutions.com', '947-119-1147', '277 Jenna Crossing');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (48, 'Dick', 'Flowitt', 'dflowitt1b@webnode.com', '202-932-8891', '4 American Terrace');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (49, 'Jamill', 'Benedettini', 'jbenedettini1c@independent.co.uk', '763-796-3745', '4689 Paget Place');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (50, 'Natalya', 'Gibbs', 'ngibbs1d@mediafire.com', '309-708-1418', '3 Browning Place');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (51, 'Archie', 'Kynder', 'akynder1e@admin.ch', '716-347-0351', '5 Clyde Gallagher Junction');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (52, 'Dinah', 'Folbigg', 'dfolbigg1f@cnbc.com', '357-500-4584', '96 Waxwing Hill');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (53, 'Aaren', 'Knoles', 'aknoles1g@skyrock.com', '436-289-3383', '43341 6th Point');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (54, 'Ernaline', 'Menary', 'emenary1h@salon.com', '123-963-3356', '95587 Crowley Park');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (55, 'Marianne', 'Lilliman', 'mlilliman1i@globo.com', '410-867-1873', '4 Pepper Wood Lane');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (56, 'Kennett', 'Petti', 'kpetti1j@facebook.com', '567-349-5788', '18 Reindahl Point');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (57, 'Tonnie', 'Fetherby', 'tfetherby1k@skype.com', '489-259-5339', '248 Victoria Alley');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (58, 'Guthrey', 'Shadwick', 'gshadwick1l@prlog.org', '711-444-4841', '2528 Sullivan Lane');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (59, 'Georgetta', 'Mellers', 'gmellers1m@aol.com', '246-290-1939', '191 Mendota Lane');
insert into Players (player_id, firstName, lastName, email, phone, address)
values (60, 'Madelena', 'Outlaw', 'moutlaw1n@house.gov', '642-506-4039', '71 Oxford Plaza');

insert into Practices (practice_id, date, time, state, city, park)
values (1, '2023-06-04', '2:38:56', 'FL', 'Greenwood', 'Riverside Park');
insert into Practices (practice_id, date, time, state, city, park)
values (2, '2023-05-12', '6:08:45', 'CA', 'Willow Creek', 'Lakeside Park');
insert into Practices (practice_id, date, time, state, city, park)
values (3, '2024-03-17', '16:57:22', 'KS', 'Sunnydale', 'Meadowview Park');
insert into Practices (practice_id, date, time, state, city, park)
values (4, '2023-09-13', '8:25:36', 'PA', 'Lakeside', 'Willow Creek Park');
insert into Practices (practice_id, date, time, state, city, park)
values (5, '2024-01-14', '15:41:54', 'ND', 'Cedar Falls', 'Sunset Park');
insert into Practices (practice_id, date, time, state, city, park)
values (6, '2024-01-07', '7:59:41', 'ND', 'Cedar Falls', 'Whispering Pines Park');
insert into Practices (practice_id, date, time, state, city, park)
values (7, '2023-07-21', '8:34:56', 'WI', 'Springfield', 'Mountain View Park');
insert into Practices (practice_id, date, time, state, city, park)
values (8, '2023-07-25', '2:52:02', 'TX', 'Riverdale', 'Oak Ridge Park');
insert into Practices (practice_id, date, time, state, city, park)
values (9, '2023-07-06', '11:17:04', 'OK', 'Harborview', 'Maplewood Park');
insert into Practices (practice_id, date, time, state, city, park)
values (10, '2023-07-16', '3:35:15', 'OH', 'Sunset Valley', 'Whispering Pines Park');
insert into Practices (practice_id, date, time, state, city, park)
values (11, '2023-07-20', '18:54:22', 'RI', 'Greenwood', 'Pine Grove Park');
insert into Practices (practice_id, date, time, state, city, park)
values (12, '2023-11-26', '1:52:52', 'KS', 'Mountainview', 'Pine Grove Park');
insert into Practices (practice_id, date, time, state, city, park)
values (13, '2024-01-22', '0:47:47', 'MT', 'Greenwood', 'Sunrise Point Park');
insert into Practices (practice_id, date, time, state, city, park)
values (14, '2023-07-07', '17:29:07', 'OK', 'Meadowbrook', 'Mountain View Park');
insert into Practices (practice_id, date, time, state, city, park)
values (15, '2024-04-03', '2:30:44', 'FL', 'Lakeview', 'Hidden Hollow Park');
insert into Practices (practice_id, date, time, state, city, park)
values (16, '2023-04-30', '1:10:07', 'MT', 'Greenwood', 'Mountain View Park');
insert into Practices (practice_id, date, time, state, city, park)
values (17, '2023-07-28', '1:35:37', 'WV', 'Maplewood', 'Cedar Ridge Park');
insert into Practices (practice_id, date, time, state, city, park)
values (18, '2023-08-17', '9:37:54', 'HI', 'Fairview', 'Lakeside Park');
insert into Practices (practice_id, date, time, state, city, park)
values (19, '2023-09-10', '10:07:42', 'MS', 'Pleasantville', 'Hilltop Park');
insert into Practices (practice_id, date, time, state, city, park)
values (20, '2023-06-11', '19:15:16', 'AL', 'Lakeview', 'Hidden Hollow Park');
insert into Practices (practice_id, date, time, state, city, park)
values (21, '2024-01-08', '16:39:17', 'IN', 'Greenwood', 'Green Valley Park');
insert into Practices (practice_id, date, time, state, city, park)
values (22, '2024-01-14', '13:18:35', 'ME', 'Cedar Falls', 'Sunrise Point Park');
insert into Practices (practice_id, date, time, state, city, park)
values (23, '2023-10-04', '6:41:34', 'KS', 'Lakeview', 'Pine Grove Park');
insert into Practices (practice_id, date, time, state, city, park)
values (24, '2023-12-22', '12:17:22', 'AZ', 'Pleasantville', 'Golden Meadows Park');
insert into Practices (practice_id, date, time, state, city, park)
values (25, '2023-11-19', '20:27:57', 'PA', 'Sunnydale', 'Oak Ridge Park');
insert into Practices (practice_id, date, time, state, city, park)
values (26, '2023-05-20', '9:11:12', 'GA', 'Springfield', 'Hidden Hollow Park');
insert into Practices (practice_id, date, time, state, city, park)
values (27, '2023-07-02', '22:54:12', 'WA', 'Riverside', 'Cedar Ridge Park');
insert into Practices (practice_id, date, time, state, city, park)
values (28, '2024-02-01', '18:13:24', 'MN', 'Mountainview', 'Green Valley Park');
insert into Practices (practice_id, date, time, state, city, park)
values (29, '2023-11-05', '11:09:20', 'AL', 'Pleasantville', 'Mountain View Park');
insert into Practices (practice_id, date, time, state, city, park)
values (30, '2023-10-05', '1:24:45', 'AL', 'Cedar Falls', 'Sunrise Point Park');
insert into Practices (practice_id, date, time, state, city, park)
values (31, '2023-11-19', '23:52:13', 'NV', 'Oakdale', 'Oak Ridge Park');
insert into Practices (practice_id, date, time, state, city, park)
values (32, '2023-10-31', '23:35:36', 'IL', 'Pleasantville', 'Hidden Hollow Park');
insert into Practices (practice_id, date, time, state, city, park)
values (33, '2024-03-19', '14:15:13', 'KY', 'Sunnydale', 'Golden Meadows Park');
insert into Practices (practice_id, date, time, state, city, park)
values (34, '2024-02-18', '0:12:38', 'NV', 'Greenwood', 'Maplewood Park');
insert into Practices (practice_id, date, time, state, city, park)
values (35, '2023-10-16', '1:19:23', 'NV', 'Greenwood', 'Pine Grove Park');
insert into Practices (practice_id, date, time, state, city, park)
values (36, '2023-07-03', '11:15:12', 'ID', 'Pinehurst', 'Sunnydale Park');
insert into Practices (practice_id, date, time, state, city, park)
values (37, '2023-11-14', '5:55:22', 'NC', 'Mountainview', 'Lakeside Park');
insert into Practices (practice_id, date, time, state, city, park)
values (38, '2023-10-27', '9:38:06', 'NJ', 'Springfield', 'Cedar Ridge Park');
insert into Practices (practice_id, date, time, state, city, park)
values (39, '2023-05-17', '6:50:53', 'OK', 'Lakeside', 'Oak Ridge Park');
insert into Practices (practice_id, date, time, state, city, park)
values (40, '2023-07-19', '13:12:09', 'MS', 'Willow Creek', 'Golden Meadows Park');
insert into Practices (practice_id, date, time, state, city, park)
values (41, '2024-02-28', '2:23:07', 'NE', 'Meadowbrook', 'Riverside Park');
insert into Practices (practice_id, date, time, state, city, park)
values (42, '2023-10-20', '20:30:37', 'SC', 'Fairview', 'Lakeside Park');
insert into Practices (practice_id, date, time, state, city, park)
values (43, '2023-06-17', '22:35:47', 'VA', 'Pleasantville', 'Sunset Park');
insert into Practices (practice_id, date, time, state, city, park)
values (44, '2024-02-03', '15:00:42', 'NJ', 'Fairview', 'Hidden Hollow Park');
insert into Practices (practice_id, date, time, state, city, park)
values (45, '2023-08-20', '7:23:09', 'IL', 'Mountainview', 'Silver Lake Park');
insert into Practices (practice_id, date, time, state, city, park)
values (46, '2023-06-21', '16:14:14', 'SD', 'Harborview', 'Riverside Park');
insert into Practices (practice_id, date, time, state, city, park)
values (47, '2024-01-15', '7:35:32', 'NM', 'Pinecrest', 'Sunset Park');
insert into Practices (practice_id, date, time, state, city, park)
values (48, '2023-06-08', '15:54:26', 'NC', 'Lakeside', 'Silver Lake Park');
insert into Practices (practice_id, date, time, state, city, park)
values (49, '2023-12-18', '5:19:09', 'NJ', 'Meadowbrook', 'Riverside Park');
insert into Practices (practice_id, date, time, state, city, park)
values (50, '2023-08-22', '19:32:49', 'MN', 'Pinecrest', 'Hilltop Park');
insert into Practices (practice_id, date, time, state, city, park)
values (51, '2023-11-16', '10:14:58', 'MD', 'Pinehurst', 'Oak Ridge Park');
insert into Practices (practice_id, date, time, state, city, park)
values (52, '2023-09-08', '16:30:48', 'NY', 'Oakdale', 'Whispering Pines Park');
insert into Practices (practice_id, date, time, state, city, park)
values (53, '2024-01-22', '5:25:26', 'WA', 'Greenwood', 'Oak Ridge Park');
insert into Practices (practice_id, date, time, state, city, park)
values (54, '2024-03-05', '19:08:12', 'TX', 'Greenwood', 'Riverside Park');
insert into Practices (practice_id, date, time, state, city, park)
values (55, '2023-05-25', '4:43:53', 'KS', 'Sunnydale', 'Mountain View Park');
insert into Practices (practice_id, date, time, state, city, park)
values (56, '2023-04-26', '18:45:42', 'WA', 'Fairview', 'Maplewood Park');
insert into Practices (practice_id, date, time, state, city, park)
values (57, '2023-06-07', '23:33:25', 'MD', 'Oakdale', 'Whispering Pines Park');
insert into Practices (practice_id, date, time, state, city, park)
values (58, '2024-01-12', '15:16:40', 'FL', 'Riverside', 'Maplewood Park');
insert into Practices (practice_id, date, time, state, city, park)
values (59, '2023-05-23', '1:08:24', 'ND', 'Hillcrest', 'Sunset Park');
insert into Practices (practice_id, date, time, state, city, park)
values (60, '2023-10-06', '22:49:55', 'TN', 'Pinehurst', 'Sunset Park');

insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (1, 'Brandise', 'Titcom', 'btitcom0@pbs.org', '228-690-4304', '5 Melrose Alley', 42);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (2, 'Crissie', 'Chaters', 'cchaters1@opensource.org', '859-869-8989', '2055 Moland Terrace', 54);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (3, 'Gregory', 'Youell', 'gyouell2@comsenz.com', '638-839-6484', '09566 Warrior Pass', 29);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (4, 'Jason', 'Darling', 'jdarling3@businesswire.com', '496-917-4427', '1 Oxford Park', 58);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (5, 'Farlee', 'Itchingham', 'fitchingham4@rakuten.co.jp', '299-324-6763', '8528 Express Terrace', 39);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (6, 'Meaghan', 'Streeton', 'mstreeton5@sourceforge.net', '244-830-6402', '5 Fieldstone Lane', 47);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (7, 'Claudina', 'Saffer', 'csaffer6@homestead.com', '309-625-6147', '07 Kipling Parkway', 57);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (8, 'Elisabeth', 'MacDonald', 'emacdonald7@biglobe.ne.jp', '802-830-5323', '681 Westend Lane', 14);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (9, 'Luke', 'Simonassi', 'lsimonassi8@forbes.com', '615-755-3892', '59109 Caliangt Park', 21);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (10, 'Sam', 'Chorlton', 'schorlton9@princeton.edu', '922-647-0172', '55 Sheridan Park', 13);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (11, 'Dalia', 'Faye', 'dfayea@blogger.com', '354-246-9880', '031 Marcy Avenue', 36);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (12, 'Doug', 'Digle', 'ddigleb@nasa.gov', '474-398-8284', '32538 Dixon Junction', 56);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (13, 'Magdalena', 'Goward', 'mgowardc@networksolutions.com', '274-265-8375', '36 Thierer Point', 11);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (14, 'Rosella', 'Giddins', 'rgiddinsd@smh.com.au', '243-333-5051', '2 Corscot Crossing', 52);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (15, 'Kurt', 'Rabley', 'krableye@mashable.com', '548-110-3698', '8292 Kennedy Street', 30);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (16, 'Ruthann', 'Wethered', 'rwetheredf@devhub.com', '225-326-3576', '3 Memorial Trail', 32);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (17, 'Jessie', 'Crighton', 'jcrightong@freewebs.com', '121-416-0763', '719 Algoma Drive', 35);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (18, 'Jarrad', 'Edgson', 'jedgsonh@meetup.com', '464-622-6156', '22 Ronald Regan Hill', 6);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (19, 'Veronike', 'Thornley', 'vthornleyi@goo.ne.jp', '834-104-4532', '93 Hanover Junction', 10);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (20, 'Felicia', 'Rodgers', 'frodgersj@biblegateway.com', '386-680-7238', '394 Washington Trail', 33);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (21, 'Tyrus', 'Corrison', 'tcorrisonk@auda.org.au', '167-162-9766', '17 Cherokee Trail', 31);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (22, 'Patricia', 'Jest', 'pjestl@sina.com.cn', '293-728-3107', '74 Browning Road', 16);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (23, 'Pepillo', 'Andree', 'pandreem@eepurl.com', '808-389-3371', '5 Bay Junction', 45);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (24, 'Rikki', 'Sloley', 'rsloleyn@furl.net', '428-438-0430', '62118 West Junction', 50);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (25, 'Franciskus', 'Forre', 'fforreo@usgs.gov', '956-996-7047', '17386 Mccormick Drive', 23);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (26, 'Seamus', 'Flecknell', 'sflecknellp@mayoclinic.com', '699-694-9267', '5760 Swallow Circle', 43);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (27, 'Korella', 'Climance', 'kclimanceq@flavors.me', '340-279-1632', '756 Dapin Hill', 37);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (28, 'Georgianne', 'Colvie', 'gcolvier@illinois.edu', '188-215-4469', '241 Helena Place', 7);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (29, 'Darelle', 'Gannan', 'dgannans@washington.edu', '753-367-9556', '5712 Melby Road', 28);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (30, 'Allie', 'Gregersen', 'agregersent@amazon.com', '567-186-5798', '67280 Petterle Pass', 25);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (31, 'Toinette', 'Quarton', 'tquartonu@marketwatch.com', '821-385-6394', '8 Washington Circle', 27);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (32, 'Claire', 'Leblanc', 'cleblancv@nytimes.com', '613-353-7741', '57263 Logan Parkway', 53);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (33, 'Silvain', 'Beverage', 'sbeveragew@diigo.com', '929-797-6738', '477 Sunnyside Pass', 59);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (34, 'Jordana', 'MacCourt', 'jmaccourtx@psu.edu', '302-421-2674', '004 Hudson Plaza', 46);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (35, 'Merrili', 'Delgadillo', 'mdelgadilloy@usda.gov', '279-527-8297', '484 Hooker Parkway', 15);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (36, 'Gilligan', 'Adamo', 'gadamoz@va.gov', '288-778-8633', '24743 Division Terrace', 17);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (37, 'Prisca', 'Fortnam', 'pfortnam10@friendfeed.com', '816-381-9125', '51 Kingsford Trail', 19);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (38, 'Sherill', 'Furniss', 'sfurniss11@ftc.gov', '780-860-1687', '8549 Swallow Plaza', 48);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (39, 'Florrie', 'Arnaldi', 'farnaldi12@pinterest.com', '332-560-6704', '3336 Utah Hill', 41);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (40, 'Melodee', 'Glayzer', 'mglayzer13@indiegogo.com', '425-892-8095', '23999 Anderson Avenue', 3);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (41, 'Ranee', 'Jura', 'rjura14@archive.org', '318-825-4290', '86 Del Sol Terrace', 49);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (42, 'Gaylord', 'Redmire', 'gredmire15@wikispaces.com', '527-983-6254', '79 Toban Hill', 34);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (43, 'Jemima', 'Hawksley', 'jhawksley16@last.fm', '543-222-9150', '8177 Maywood Court', 55);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (44, 'Sonnie', 'Borsi', 'sborsi17@indiatimes.com', '965-357-9574', '38031 Farwell Circle', 38);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (45, 'Sigfrid', 'Kennsley', 'skennsley18@sun.com', '861-136-5858', '5625 Kennedy Way', 51);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (46, 'Henry', 'Paulmann', 'hpaulmann19@sitemeter.com', '710-758-5228', '933 Bluejay Center', 60);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (47, 'Dacia', 'Leggat', 'dleggat1a@symantec.com', '843-509-9379', '7060 John Wall Way', 12);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (48, 'Ellswerth', 'Lowerson', 'elowerson1b@usgs.gov', '429-958-8164', '9 Golf Way', 1);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (49, 'Shepard', 'Widd', 'swidd1c@shutterfly.com', '519-863-2752', '7012 Upham Place', 2);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (50, 'Darryl', 'Koche', 'dkoche1d@taobao.com', '409-230-2323', '71682 Green Ridge Alley', 24);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (51, 'Todd', 'Clemencet', 'tclemencet1e@1und1.de', '547-849-6114', '747 Division Park', 40);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (52, 'Hetti', 'Giroldi', 'hgiroldi1f@hc360.com', '293-634-7130', '8542 Wayridge Park', 5);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (53, 'Doti', 'Ivett', 'divett1g@nationalgeographic.com', '275-340-5109', '243 Veith Street', 8);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (54, 'Daune', 'Toplis', 'dtoplis1h@vimeo.com', '954-264-3429', '28 Lukken Terrace', 22);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (55, 'Valerie', 'Dmiterko', 'vdmiterko1i@dedecms.com', '760-447-2274', '88 Kennedy Center', 20);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (56, 'Amalee', 'Yurmanovev', 'ayurmanovev1j@dropbox.com', '987-149-4267', '0 Springview Road', 18);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (57, 'Iorgos', 'Rookwell', 'irookwell1k@umn.edu', '614-163-7985', '1039 Garrison Circle', 4);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (58, 'Sharlene', 'Cowthart', 'scowthart1l@reuters.com', '320-456-6211', '34 Hudson Court', 26);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (59, 'Jeniece', 'Feye', 'jfeye1m@whitehouse.gov', '102-428-3740', '92593 Almo Point', 9);
insert into Coaches (coach_id, firstName, lastName, email, phone, address, team_id)
values (60, 'Cullie', 'Slimmon', 'cslimmon1n@ning.com', '533-402-7369', '0405 Onsgard Trail', 44);

insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (59, 'Soccer', 67, 26, 55);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (25, 'Volleyball', 84, 61, 93);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (14, 'Rugby', 76, 61, 45);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (60, 'Basketball', 7, 68, 17);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (41, 'Volleyball', 7, 16, 50);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (40, 'Handball', 60, 79, 9);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (6, 'Basketball', 18, 61, 68);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (19, 'Water Polo', 2, 78, 57);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (26, 'American Football', 65, 1, 5);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (44, 'Basketball', 31, 28, 17);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (12, 'Basketball', 53, 95, 71);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (37, 'Basketball', 98, 43, 59);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (42, 'Rugby', 78, 98, 28);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (2, 'Basketball', 65, 4, 23);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (8, 'Rugby', 2, 93, 55);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (45, 'Basketball', 38, 49, 40);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (10, 'Rugby', 13, 14, 81);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (36, 'Rugby', 12, 11, 59);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (23, 'Volleyball', 38, 76, 82);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (58, 'Rugby', 77, 24, 7);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (18, 'American Football', 16, 65, 78);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (46, 'Field Hockey', 4, 27, 3);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (53, 'Basketball', 17, 67, 37);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (20, 'Rugby', 99, 83, 33);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (29, 'American Football', 36, 14, 16);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (11, 'Soccer', 12, 41, 5);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (30, 'Soccer', 38, 49, 98);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (55, 'Lacrosse', 100, 29, 11);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (48, 'American Football', 49, 42, 34);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (56, 'Basketball', 1, 17, 59);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (9, 'Lacrosse', 76, 89, 32);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (13, 'Basketball', 57, 28, 68);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (21, 'Volleyball', 46, 69, 52);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (22, 'Volleyball', 88, 99, 65);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (28, 'Handball', 50, 58, 45);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (1, 'Basketball', 5, 91, 11);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (31, 'American Football', 39, 70, 82);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (7, 'Field Hockey', 18, 57, 67);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (33, 'American Football', 28, 33, 62);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (5, 'Field Hockey', 3, 43, 26);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (38, 'Hockey', 37, 34, 7);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (39, 'Rugby', 95, 39, 75);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (27, 'Water Polo', 23, 26, 78);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (3, 'Field Hockey', 49, 58, 58);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (34, 'Water Polo', 12, 98, 32);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (54, 'Volleyball', 90, 51, 19);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (49, 'Water Polo', 97, 45, 67);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (35, 'Hockey', 88, 35, 54);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (32, 'Field Hockey', 10, 11, 69);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (4, 'American Football', 23, 97, 22);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (47, 'Water Polo', 82, 67, 80);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (17, 'Lacrosse', 42, 95, 61);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (51, 'Rugby', 70, 70, 99);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (57, 'Field Hockey', 57, 10, 60);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (16, 'American Football', 63, 11, 35);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (24, 'Lacrosse', 33, 84, 52);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (50, 'American Football', 52, 98, 10);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (43, 'Water Polo', 69, 76, 28);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (52, 'Rugby', 6, 38, 94);
insert into PlayerProfile (player_id, sport, fouls, assists, points)
values (15, 'Rugby', 25, 51, 92);

insert into TeamProfile (team_id, sport, points, assists, fouls)
values (5, 'American Football', 99, 65, 49);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (34, 'Basketball', 7, 30, 9);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (39, 'Rugby', 0, 64, 46);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (41, 'Hockey', 5, 62, 87);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (20, 'Handball', 94, 8, 68);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (56, 'Volleyball', 35, 75, 53);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (49, 'Volleyball', 85, 56, 48);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (46, 'American Football', 32, 44, 93);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (45, 'Field Hockey', 36, 63, 42);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (13, 'Field Hockey', 98, 42, 22);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (54, 'Hockey', 74, 52, 34);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (15, 'Soccer', 84, 96, 81);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (53, 'Volleyball', 26, 8, 91);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (42, 'Field Hockey', 36, 13, 43);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (12, 'Basketball', 61, 32, 19);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (6, 'Field Hockey', 62, 61, 68);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (23, 'American Football', 60, 32, 25);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (26, 'Volleyball', 47, 100, 47);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (18, 'Volleyball', 35, 0, 66);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (48, 'Hockey', 35, 37, 82);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (14, 'Rugby', 86, 86, 23);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (43, 'Hockey', 65, 4, 38);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (35, 'Field Hockey', 1, 40, 72);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (24, 'Soccer', 47, 88, 18);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (60, 'Field Hockey', 65, 88, 53);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (55, 'Lacrosse', 16, 70, 17);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (37, 'Hockey', 34, 94, 8);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (3, 'Soccer', 52, 5, 70);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (52, 'American Football', 85, 45, 68);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (31, 'Basketball', 31, 48, 30);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (1, 'Volleyball', 89, 63, 27);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (7, 'Lacrosse', 67, 25, 4);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (16, 'Water Polo', 34, 58, 47);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (40, 'Handball', 20, 71, 76);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (38, 'Soccer', 4, 89, 51);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (51, 'Hockey', 78, 34, 26);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (17, 'Volleyball', 0, 92, 23);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (4, 'Rugby', 44, 89, 96);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (58, 'Lacrosse', 4, 100, 71);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (47, 'Water Polo', 23, 88, 30);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (25, 'Rugby', 14, 19, 28);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (50, 'Field Hockey', 33, 56, 75);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (59, 'Water Polo', 77, 33, 83);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (9, 'Hockey', 63, 39, 64);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (29, 'American Football', 58, 28, 70);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (21, 'Water Polo', 73, 57, 43);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (19, 'Lacrosse', 48, 67, 67);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (32, 'Water Polo', 44, 2, 58);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (2, 'Hockey', 55, 13, 30);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (33, 'Basketball', 37, 67, 90);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (28, 'Volleyball', 45, 39, 24);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (10, 'American Football', 70, 19, 19);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (57, 'Handball', 87, 64, 24);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (27, 'American Football', 35, 29, 98);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (8, 'Basketball', 59, 68, 45);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (11, 'Water Polo', 81, 94, 16);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (36, 'Lacrosse', 98, 71, 7);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (22, 'Water Polo', 35, 93, 60);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (44, 'Field Hockey', 60, 80, 58);
insert into TeamProfile (team_id, sport, points, assists, fouls)
values (30, 'Lacrosse', 14, 56, 97);

insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (60, 36, 93, 32, 45);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (59, 20, 4, 30, 67);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (40, 10, 93, 18, 46);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (22, 58, 74, 16, 84);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (11, 13, 88, 67, 15);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (19, 32, 40, 19, 9);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (30, 12, 38, 12, 36);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (6, 40, 66, 53, 52);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (38, 24, 85, 100, 79);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (17, 48, 50, 44, 26);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (7, 38, 66, 59, 66);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (16, 34, 42, 46, 11);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (47, 3, 85, 95, 81);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (52, 41, 31, 67, 50);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (1, 52, 67, 95, 46);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (15, 14, 87, 73, 50);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (50, 49, 91, 54, 10);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (26, 31, 7, 49, 97);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (12, 19, 19, 33, 33);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (9, 16, 63, 86, 17);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (25, 17, 55, 62, 85);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (14, 33, 25, 41, 10);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (31, 35, 6, 94, 64);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (39, 23, 63, 70, 60);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (18, 45, 26, 33, 99);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (45, 43, 35, 10, 78);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (48, 30, 26, 26, 9);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (43, 25, 8, 21, 98);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (33, 42, 39, 97, 26);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (3, 22, 99, 49, 92);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (56, 57, 49, 45, 93);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (21, 51, 93, 90, 55);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (55, 46, 92, 91, 35);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (57, 8, 81, 58, 89);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (58, 26, 59, 26, 88);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (10, 60, 73, 94, 29);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (36, 29, 1, 90, 75);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (4, 39, 31, 94, 6);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (44, 11, 33, 93, 75);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (41, 54, 92, 62, 21);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (5, 15, 80, 78, 45);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (23, 44, 30, 69, 28);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (13, 27, 83, 65, 22);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (54, 6, 7, 34, 92);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (29, 28, 85, 85, 67);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (24, 21, 77, 32, 55);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (51, 53, 55, 46, 79);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (34, 7, 29, 74, 42);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (2, 9, 35, 37, 89);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (27, 47, 78, 74, 69);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (49, 55, 65, 42, 89);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (35, 4, 18, 45, 48);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (42, 2, 41, 17, 64);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (46, 1, 43, 68, 12);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (37, 56, 81, 93, 83);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (20, 59, 86, 12, 91);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (8, 37, 58, 24, 66);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (32, 5, 33, 92, 21);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (28, 18, 48, 67, 52);
insert into PlayerStats (player_id, game_id, points, assists, fouls)
values (53, 50, 16, 89, 3);

insert into TeamStats (team_id, game_id, points, assists, fouls)
values (45, 44, 8, 92, 40);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (56, 58, 75, 25, 67);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (33, 34, 23, 2, 67);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (18, 53, 28, 96, 18);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (44, 60, 21, 48, 16);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (41, 8, 76, 60, 87);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (15, 24, 61, 73, 9);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (29, 16, 58, 46, 38);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (50, 48, 91, 62, 11);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (49, 23, 5, 78, 90);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (25, 29, 78, 34, 88);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (42, 47, 7, 65, 84);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (20, 28, 76, 20, 5);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (19, 17, 84, 9, 21);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (11, 11, 30, 56, 83);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (52, 20, 0, 4, 62);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (36, 13, 25, 45, 66);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (26, 36, 0, 15, 49);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (13, 43, 91, 83, 77);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (5, 41, 42, 7, 17);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (2, 12, 67, 74, 85);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (12, 18, 1, 50, 17);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (46, 27, 17, 76, 1);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (27, 21, 85, 14, 6);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (10, 35, 87, 82, 75);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (28, 9, 30, 75, 69);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (58, 45, 88, 29, 94);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (7, 4, 98, 52, 6);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (40, 40, 5, 26, 78);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (54, 54, 52, 50, 67);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (39, 25, 52, 75, 86);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (9, 46, 86, 92, 55);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (22, 37, 9, 11, 93);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (47, 5, 57, 20, 32);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (21, 3, 78, 94, 56);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (38, 50, 90, 59, 63);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (24, 38, 66, 69, 51);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (30, 56, 82, 21, 65);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (1, 51, 79, 93, 43);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (35, 10, 89, 61, 96);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (3, 31, 61, 92, 81);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (8, 30, 17, 53, 5);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (14, 39, 54, 60, 50);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (53, 7, 53, 37, 38);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (32, 22, 5, 57, 25);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (23, 52, 35, 58, 31);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (60, 6, 34, 3, 31);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (37, 1, 61, 36, 100);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (43, 49, 15, 39, 17);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (6, 55, 39, 44, 6);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (17, 14, 50, 18, 63);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (48, 15, 25, 39, 46);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (16, 59, 4, 65, 100);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (55, 2, 77, 6, 73);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (4, 42, 97, 46, 61);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (59, 33, 41, 15, 9);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (34, 32, 55, 53, 12);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (57, 57, 92, 0, 44);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (51, 19, 15, 3, 95);
insert into TeamStats (team_id, game_id, points, assists, fouls)
values (31, 26, 80, 35, 0);

insert into GameAttendance (game_id, player_id)
values (58, 13);
insert into GameAttendance (game_id, player_id)
values (25, 24);
insert into GameAttendance (game_id, player_id)
values (24, 46);
insert into GameAttendance (game_id, player_id)
values (26, 40);
insert into GameAttendance (game_id, player_id)
values (5, 31);
insert into GameAttendance (game_id, player_id)
values (45, 36);
insert into GameAttendance (game_id, player_id)
values (59, 10);
insert into GameAttendance (game_id, player_id)
values (27, 37);
insert into GameAttendance (game_id, player_id)
values (43, 56);
insert into GameAttendance (game_id, player_id)
values (42, 41);
insert into GameAttendance (game_id, player_id)
values (37, 23);
insert into GameAttendance (game_id, player_id)
values (41, 33);
insert into GameAttendance (game_id, player_id)
values (38, 53);
insert into GameAttendance (game_id, player_id)
values (33, 48);
insert into GameAttendance (game_id, player_id)
values (48, 5);
insert into GameAttendance (game_id, player_id)
values (13, 58);
insert into GameAttendance (game_id, player_id)
values (46, 19);
insert into GameAttendance (game_id, player_id)
values (32, 34);
insert into GameAttendance (game_id, player_id)
values (29, 39);
insert into GameAttendance (game_id, player_id)
values (17, 57);
insert into GameAttendance (game_id, player_id)
values (60, 59);
insert into GameAttendance (game_id, player_id)
values (12, 26);
insert into GameAttendance (game_id, player_id)
values (11, 6);
insert into GameAttendance (game_id, player_id)
values (52, 21);
insert into GameAttendance (game_id, player_id)
values (7, 38);
insert into GameAttendance (game_id, player_id)
values (39, 12);
insert into GameAttendance (game_id, player_id)
values (2, 17);
insert into GameAttendance (game_id, player_id)
values (15, 51);
insert into GameAttendance (game_id, player_id)
values (55, 9);
insert into GameAttendance (game_id, player_id)
values (50, 7);
insert into GameAttendance (game_id, player_id)
values (9, 14);
insert into GameAttendance (game_id, player_id)
values (54, 42);
insert into GameAttendance (game_id, player_id)
values (30, 15);
insert into GameAttendance (game_id, player_id)
values (20, 50);
insert into GameAttendance (game_id, player_id)
values (36, 32);
insert into GameAttendance (game_id, player_id)
values (56, 45);
insert into GameAttendance (game_id, player_id)
values (1, 44);
insert into GameAttendance (game_id, player_id)
values (16, 27);
insert into GameAttendance (game_id, player_id)
values (51, 16);
insert into GameAttendance (game_id, player_id)
values (28, 28);
insert into GameAttendance (game_id, player_id)
values (57, 20);
insert into GameAttendance (game_id, player_id)
values (23, 47);
insert into GameAttendance (game_id, player_id)
values (34, 3);
insert into GameAttendance (game_id, player_id)
values (40, 52);
insert into GameAttendance (game_id, player_id)
values (19, 30);
insert into GameAttendance (game_id, player_id)
values (4, 18);
insert into GameAttendance (game_id, player_id)
values (49, 1);
insert into GameAttendance (game_id, player_id)
values (31, 29);
insert into GameAttendance (game_id, player_id)
values (10, 43);
insert into GameAttendance (game_id, player_id)
values (47, 2);
insert into GameAttendance (game_id, player_id)
values (18, 55);
insert into GameAttendance (game_id, player_id)
values (8, 35);
insert into GameAttendance (game_id, player_id)
values (22, 54);
insert into GameAttendance (game_id, player_id)
values (44, 60);
insert into GameAttendance (game_id, player_id)
values (35, 4);
insert into GameAttendance (game_id, player_id)
values (21, 8);
insert into GameAttendance (game_id, player_id)
values (53, 49);
insert into GameAttendance (game_id, player_id)
values (14, 22);
insert into GameAttendance (game_id, player_id)
values (3, 11);
insert into GameAttendance (game_id, player_id)
values (6, 25);
insert into GameAttendance (game_id, player_id)
values (39, 30);
insert into GameAttendance (game_id, player_id)
values (14, 46);
insert into GameAttendance (game_id, player_id)
values (24, 49);
insert into GameAttendance (game_id, player_id)
values (43, 16);
insert into GameAttendance (game_id, player_id)
values (16, 4);
insert into GameAttendance (game_id, player_id)
values (1, 8);
insert into GameAttendance (game_id, player_id)
values (45, 44);
insert into GameAttendance (game_id, player_id)
values (6, 6);
insert into GameAttendance (game_id, player_id)
values (22, 47);
insert into GameAttendance (game_id, player_id)
values (36, 55);
insert into GameAttendance (game_id, player_id)
values (7, 18);
insert into GameAttendance (game_id, player_id)
values (47, 38);
insert into GameAttendance (game_id, player_id)
values (33, 37);
insert into GameAttendance (game_id, player_id)
values (21, 56);
insert into GameAttendance (game_id, player_id)
values (32, 25);
insert into GameAttendance (game_id, player_id)
values (31, 39);
insert into GameAttendance (game_id, player_id)
values (41, 48);
insert into GameAttendance (game_id, player_id)
values (18, 29);
insert into GameAttendance (game_id, player_id)
values (29, 28);
insert into GameAttendance (game_id, player_id)
values (10, 13);
insert into GameAttendance (game_id, player_id)
values (55, 51);
insert into GameAttendance (game_id, player_id)
values (3, 3);
insert into GameAttendance (game_id, player_id)
values (52, 57);
insert into GameAttendance (game_id, player_id)
values (58, 43);
insert into GameAttendance (game_id, player_id)
values (28, 17);
insert into GameAttendance (game_id, player_id)
values (59, 11);
insert into GameAttendance (game_id, player_id)
values (42, 36);
insert into GameAttendance (game_id, player_id)
values (15, 59);
insert into GameAttendance (game_id, player_id)
values (34, 53);
insert into GameAttendance (game_id, player_id)
values (56, 32);
insert into GameAttendance (game_id, player_id)
values (40, 15);
insert into GameAttendance (game_id, player_id)
values (49, 31);
insert into GameAttendance (game_id, player_id)
values (20, 42);
insert into GameAttendance (game_id, player_id)
values (51, 60);
insert into GameAttendance (game_id, player_id)
values (23, 2);
insert into GameAttendance (game_id, player_id)
values (8, 12);
insert into GameAttendance (game_id, player_id)
values (57, 7);
insert into GameAttendance (game_id, player_id)
values (13, 41);
insert into GameAttendance (game_id, player_id)
values (50, 40);
insert into GameAttendance (game_id, player_id)
values (46, 58);
insert into GameAttendance (game_id, player_id)
values (35, 52);
insert into GameAttendance (game_id, player_id)
values (53, 5);
insert into GameAttendance (game_id, player_id)
values (38, 1);
insert into GameAttendance (game_id, player_id)
values (4, 10);
insert into GameAttendance (game_id, player_id)
values (2, 35);
insert into GameAttendance (game_id, player_id)
values (17, 9);
insert into GameAttendance (game_id, player_id)
values (54, 54);
insert into GameAttendance (game_id, player_id)
values (19, 45);
insert into GameAttendance (game_id, player_id)
values (25, 33);
insert into GameAttendance (game_id, player_id)
values (9, 20);
insert into GameAttendance (game_id, player_id)
values (44, 27);
insert into GameAttendance (game_id, player_id)
values (12, 34);
insert into GameAttendance (game_id, player_id)
values (26, 23);
insert into GameAttendance (game_id, player_id)
values (30, 21);
insert into GameAttendance (game_id, player_id)
values (60, 26);
insert into GameAttendance (game_id, player_id)
values (11, 50);
insert into GameAttendance (game_id, player_id)
values (5, 22);
insert into GameAttendance (game_id, player_id)
values (48, 19);
insert into GameAttendance (game_id, player_id)
values (27, 14);
insert into GameAttendance (game_id, player_id)
values (37, 24);
insert into GameAttendance (game_id, player_id)
values (19, 10);
insert into GameAttendance (game_id, player_id)
values (15, 7);
insert into GameAttendance (game_id, player_id)
values (52, 60);
insert into GameAttendance (game_id, player_id)
values (50, 17);
insert into GameAttendance (game_id, player_id)
values (46, 32);
insert into GameAttendance (game_id, player_id)
values (29, 8);
insert into GameAttendance (game_id, player_id)
values (47, 41);
insert into GameAttendance (game_id, player_id)
values (60, 54);
insert into GameAttendance (game_id, player_id)
values (4, 50);
insert into GameAttendance (game_id, player_id)
values (1, 56);
insert into GameAttendance (game_id, player_id)
values (18, 14);
insert into GameAttendance (game_id, player_id)
values (44, 24);
insert into GameAttendance (game_id, player_id)
values (6, 9);
insert into GameAttendance (game_id, player_id)
values (30, 52);
insert into GameAttendance (game_id, player_id)
values (48, 36);
insert into GameAttendance (game_id, player_id)
values (59, 27);
insert into GameAttendance (game_id, player_id)
values (32, 13);
insert into GameAttendance (game_id, player_id)
values (17, 23);
insert into GameAttendance (game_id, player_id)
values (11, 34);
insert into GameAttendance (game_id, player_id)
values (58, 28);
insert into GameAttendance (game_id, player_id)
values (8, 11);
insert into GameAttendance (game_id, player_id)
values (31, 22);
insert into GameAttendance (game_id, player_id)
values (41, 49);
insert into GameAttendance (game_id, player_id)
values (5, 39);
insert into GameAttendance (game_id, player_id)
values (35, 25);
insert into GameAttendance (game_id, player_id)
values (34, 20);
insert into GameAttendance (game_id, player_id)
values (20, 5);
insert into GameAttendance (game_id, player_id)
values (14, 38);
insert into GameAttendance (game_id, player_id)
values (28, 58);
insert into GameAttendance (game_id, player_id)
values (53, 59);
insert into GameAttendance (game_id, player_id)
values (45, 29);
insert into GameAttendance (game_id, player_id)
values (38, 19);
insert into GameAttendance (game_id, player_id)
values (39, 46);
insert into GameAttendance (game_id, player_id)
values (40, 16);
insert into GameAttendance (game_id, player_id)
values (21, 6);
insert into GameAttendance (game_id, player_id)
values (54, 44);
insert into GameAttendance (game_id, player_id)
values (57, 35);
insert into GameAttendance (game_id, player_id)
values (9, 1);
insert into GameAttendance (game_id, player_id)
values (27, 3);
insert into GameAttendance (game_id, player_id)
values (12, 47);
insert into GameAttendance (game_id, player_id)
values (23, 18);
insert into GameAttendance (game_id, player_id)
values (25, 21);
insert into GameAttendance (game_id, player_id)
values (24, 40);
insert into GameAttendance (game_id, player_id)
values (55, 37);
insert into GameAttendance (game_id, player_id)
values (3, 53);
insert into GameAttendance (game_id, player_id)
values (2, 57);
insert into GameAttendance (game_id, player_id)
values (51, 43);
insert into GameAttendance (game_id, player_id)
values (49, 30);
insert into GameAttendance (game_id, player_id)
values (26, 12);
insert into GameAttendance (game_id, player_id)
values (42, 51);
insert into GameAttendance (game_id, player_id)
values (56, 2);
insert into GameAttendance (game_id, player_id)
values (10, 48);
insert into GameAttendance (game_id, player_id)
values (36, 42);
insert into GameAttendance (game_id, player_id)
values (16, 33);
insert into GameAttendance (game_id, player_id)
values (22, 31);
insert into GameAttendance (game_id, player_id)
values (43, 45);
insert into GameAttendance (game_id, player_id)
values (37, 16);
insert into GameAttendance (game_id, player_id)
values (33, 55);
insert into GameAttendance (game_id, player_id)
values (13, 4);
insert into GameAttendance (game_id, player_id)
values (7, 26);
insert into GameAttendance (game_id, player_id)
values (54, 48);
insert into GameAttendance (game_id, player_id)
values (27, 49);
insert into GameAttendance (game_id, player_id)
values (47, 33);
insert into GameAttendance (game_id, player_id)
values (25, 46);
insert into GameAttendance (game_id, player_id)
values (49, 47);
insert into GameAttendance (game_id, player_id)
values (46, 53);
insert into GameAttendance (game_id, player_id)
values (21, 32);
insert into GameAttendance (game_id, player_id)
values (22, 59);
insert into GameAttendance (game_id, player_id)
values (10, 60);
insert into GameAttendance (game_id, player_id)
values (51, 21);
insert into GameAttendance (game_id, player_id)
values (53, 23);
insert into GameAttendance (game_id, player_id)
values (7, 51);
insert into GameAttendance (game_id, player_id)
values (40, 35);
insert into GameAttendance (game_id, player_id)
values (24, 43);
insert into GameAttendance (game_id, player_id)
values (45, 52);
insert into GameAttendance (game_id, player_id)
values (52, 5);
insert into GameAttendance (game_id, player_id)
values (32, 36);
insert into GameAttendance (game_id, player_id)
values (4, 41);
insert into GameAttendance (game_id, player_id)
values (50, 27);
insert into GameAttendance (game_id, player_id)
values (59, 31);

insert into PracticeAttendance (practice_id, player_id)
values (20, 22);
insert into PracticeAttendance (practice_id, player_id)
values (43, 28);
insert into PracticeAttendance (practice_id, player_id)
values (59, 53);
insert into PracticeAttendance (practice_id, player_id)
values (46, 39);
insert into PracticeAttendance (practice_id, player_id)
values (31, 9);
insert into PracticeAttendance (practice_id, player_id)
values (42, 60);
insert into PracticeAttendance (practice_id, player_id)
values (14, 23);
insert into PracticeAttendance (practice_id, player_id)
values (5, 50);
insert into PracticeAttendance (practice_id, player_id)
values (13, 5);
insert into PracticeAttendance (practice_id, player_id)
values (36, 31);
insert into PracticeAttendance (practice_id, player_id)
values (18, 26);
insert into PracticeAttendance (practice_id, player_id)
values (24, 48);
insert into PracticeAttendance (practice_id, player_id)
values (52, 3);
insert into PracticeAttendance (practice_id, player_id)
values (7, 21);
insert into PracticeAttendance (practice_id, player_id)
values (38, 58);
insert into PracticeAttendance (practice_id, player_id)
values (6, 37);
insert into PracticeAttendance (practice_id, player_id)
values (49, 36);
insert into PracticeAttendance (practice_id, player_id)
values (9, 35);
insert into PracticeAttendance (practice_id, player_id)
values (21, 45);
insert into PracticeAttendance (practice_id, player_id)
values (12, 7);
insert into PracticeAttendance (practice_id, player_id)
values (22, 16);
insert into PracticeAttendance (practice_id, player_id)
values (51, 15);
insert into PracticeAttendance (practice_id, player_id)
values (60, 19);
insert into PracticeAttendance (practice_id, player_id)
values (53, 32);
insert into PracticeAttendance (practice_id, player_id)
values (54, 43);
insert into PracticeAttendance (practice_id, player_id)
values (50, 55);
insert into PracticeAttendance (practice_id, player_id)
values (16, 41);
insert into PracticeAttendance (practice_id, player_id)
values (44, 54);
insert into PracticeAttendance (practice_id, player_id)
values (26, 44);
insert into PracticeAttendance (practice_id, player_id)
values (17, 52);
insert into PracticeAttendance (practice_id, player_id)
values (28, 47);
insert into PracticeAttendance (practice_id, player_id)
values (35, 25);
insert into PracticeAttendance (practice_id, player_id)
values (48, 13);
insert into PracticeAttendance (practice_id, player_id)
values (37, 11);
insert into PracticeAttendance (practice_id, player_id)
values (4, 49);
insert into PracticeAttendance (practice_id, player_id)
values (1, 27);
insert into PracticeAttendance (practice_id, player_id)
values (58, 46);
insert into PracticeAttendance (practice_id, player_id)
values (34, 20);
insert into PracticeAttendance (practice_id, player_id)
values (29, 34);
insert into PracticeAttendance (practice_id, player_id)
values (8, 29);
insert into PracticeAttendance (practice_id, player_id)
values (41, 6);
insert into PracticeAttendance (practice_id, player_id)
values (55, 12);
insert into PracticeAttendance (practice_id, player_id)
values (19, 40);
insert into PracticeAttendance (practice_id, player_id)
values (40, 24);
insert into PracticeAttendance (practice_id, player_id)
values (11, 57);
insert into PracticeAttendance (practice_id, player_id)
values (45, 51);
insert into PracticeAttendance (practice_id, player_id)
values (3, 30);
insert into PracticeAttendance (practice_id, player_id)
values (15, 38);
insert into PracticeAttendance (practice_id, player_id)
values (10, 42);
insert into PracticeAttendance (practice_id, player_id)
values (47, 2);
insert into PracticeAttendance (practice_id, player_id)
values (2, 10);
insert into PracticeAttendance (practice_id, player_id)
values (27, 56);
insert into PracticeAttendance (practice_id, player_id)
values (30, 18);
insert into PracticeAttendance (practice_id, player_id)
values (23, 59);
insert into PracticeAttendance (practice_id, player_id)
values (32, 14);
insert into PracticeAttendance (practice_id, player_id)
values (39, 8);
insert into PracticeAttendance (practice_id, player_id)
values (33, 33);
insert into PracticeAttendance (practice_id, player_id)
values (25, 1);
insert into PracticeAttendance (practice_id, player_id)
values (56, 17);
insert into PracticeAttendance (practice_id, player_id)
values (57, 4);
insert into PracticeAttendance (practice_id, player_id)
values (45, 7);
insert into PracticeAttendance (practice_id, player_id)
values (60, 54);
insert into PracticeAttendance (practice_id, player_id)
values (5, 28);
insert into PracticeAttendance (practice_id, player_id)
values (52, 52);
insert into PracticeAttendance (practice_id, player_id)
values (41, 46);
insert into PracticeAttendance (practice_id, player_id)
values (11, 31);
insert into PracticeAttendance (practice_id, player_id)
values (39, 24);
insert into PracticeAttendance (practice_id, player_id)
values (46, 36);
insert into PracticeAttendance (practice_id, player_id)
values (30, 53);
insert into PracticeAttendance (practice_id, player_id)
values (55, 56);
insert into PracticeAttendance (practice_id, player_id)
values (35, 15);
insert into PracticeAttendance (practice_id, player_id)
values (48, 33);
insert into PracticeAttendance (practice_id, player_id)
values (22, 49);
insert into PracticeAttendance (practice_id, player_id)
values (16, 1);
insert into PracticeAttendance (practice_id, player_id)
values (28, 48);
insert into PracticeAttendance (practice_id, player_id)
values (8, 47);
insert into PracticeAttendance (practice_id, player_id)
values (13, 6);
insert into PracticeAttendance (practice_id, player_id)
values (14, 25);
insert into PracticeAttendance (practice_id, player_id)
values (21, 27);
insert into PracticeAttendance (practice_id, player_id)
values (25, 2);
insert into PracticeAttendance (practice_id, player_id)
values (12, 17);
insert into PracticeAttendance (practice_id, player_id)
values (43, 57);
insert into PracticeAttendance (practice_id, player_id)
values (37, 12);
insert into PracticeAttendance (practice_id, player_id)
values (24, 41);
insert into PracticeAttendance (practice_id, player_id)
values (49, 22);
insert into PracticeAttendance (practice_id, player_id)
values (23, 55);
insert into PracticeAttendance (practice_id, player_id)
values (33, 50);
insert into PracticeAttendance (practice_id, player_id)
values (19, 41);
insert into PracticeAttendance (practice_id, player_id)
values (15, 11);
insert into PracticeAttendance (practice_id, player_id)
values (36, 16);
insert into PracticeAttendance (practice_id, player_id)
values (7, 44);
insert into PracticeAttendance (practice_id, player_id)
values (47, 58);
insert into PracticeAttendance (practice_id, player_id)
values (10, 51);
insert into PracticeAttendance (practice_id, player_id)
values (31, 30);
insert into PracticeAttendance (practice_id, player_id)
values (58, 3);
insert into PracticeAttendance (practice_id, player_id)
values (17, 18);
insert into PracticeAttendance (practice_id, player_id)
values (4, 43);
insert into PracticeAttendance (practice_id, player_id)
values (34, 9);
insert into PracticeAttendance (practice_id, player_id)
values (2, 59);
insert into PracticeAttendance (practice_id, player_id)
values (59, 26);
insert into PracticeAttendance (practice_id, player_id)
values (44, 13);
insert into PracticeAttendance (practice_id, player_id)
values (18, 29);
insert into PracticeAttendance (practice_id, player_id)
values (27, 21);
insert into PracticeAttendance (practice_id, player_id)
values (51, 32);
insert into PracticeAttendance (practice_id, player_id)
values (42, 8);
insert into PracticeAttendance (practice_id, player_id)
values (32, 19);
insert into PracticeAttendance (practice_id, player_id)
values (26, 34);
insert into PracticeAttendance (practice_id, player_id)
values (57, 14);
insert into PracticeAttendance (practice_id, player_id)
values (53, 37);
insert into PracticeAttendance (practice_id, player_id)
values (29, 20);
insert into PracticeAttendance (practice_id, player_id)
values (6, 39);
insert into PracticeAttendance (practice_id, player_id)
values (56, 60);
insert into PracticeAttendance (practice_id, player_id)
values (3, 42);
insert into PracticeAttendance (practice_id, player_id)
values (1, 35);
insert into PracticeAttendance (practice_id, player_id)
values (20, 45);
insert into PracticeAttendance (practice_id, player_id)
values (54, 23);
insert into PracticeAttendance (practice_id, player_id)
values (9, 4);
insert into PracticeAttendance (practice_id, player_id)
values (38, 10);
insert into PracticeAttendance (practice_id, player_id)
values (50, 6);
insert into PracticeAttendance (practice_id, player_id)
values (40, 38);
insert into PracticeAttendance (practice_id, player_id)
values (11, 11);
insert into PracticeAttendance (practice_id, player_id)
values (22, 18);
insert into PracticeAttendance (practice_id, player_id)
values (7, 6);
insert into PracticeAttendance (practice_id, player_id)
values (25, 57);
insert into PracticeAttendance (practice_id, player_id)
values (56, 40);
insert into PracticeAttendance (practice_id, player_id)
values (53, 44);
insert into PracticeAttendance (practice_id, player_id)
values (60, 23);
insert into PracticeAttendance (practice_id, player_id)
values (19, 42);
insert into PracticeAttendance (practice_id, player_id)
values (40, 13);
insert into PracticeAttendance (practice_id, player_id)
values (51, 53);
insert into PracticeAttendance (practice_id, player_id)
values (55, 17);
insert into PracticeAttendance (practice_id, player_id)
values (49, 3);
insert into PracticeAttendance (practice_id, player_id)
values (36, 58);
insert into PracticeAttendance (practice_id, player_id)
values (18, 32);
insert into PracticeAttendance (practice_id, player_id)
values (29, 50);
insert into PracticeAttendance (practice_id, player_id)
values (20, 54);
insert into PracticeAttendance (practice_id, player_id)
values (41, 48);
insert into PracticeAttendance (practice_id, player_id)
values (58, 10);
insert into PracticeAttendance (practice_id, player_id)
values (47, 59);
insert into PracticeAttendance (practice_id, player_id)
values (24, 27);
insert into PracticeAttendance (practice_id, player_id)
values (1, 29);
insert into PracticeAttendance (practice_id, player_id)
values (42, 22);
insert into PracticeAttendance (practice_id, player_id)
values (48, 34);
insert into PracticeAttendance (practice_id, player_id)
values (26, 35);
insert into PracticeAttendance (practice_id, player_id)
values (45, 38);
insert into PracticeAttendance (practice_id, player_id)
values (38, 45);
insert into PracticeAttendance (practice_id, player_id)
values (44, 4);
insert into PracticeAttendance (practice_id, player_id)
values (33, 2);
insert into PracticeAttendance (practice_id, player_id)
values (8, 21);
insert into PracticeAttendance (practice_id, player_id)
values (2, 16);
insert into PracticeAttendance (practice_id, player_id)
values (34, 39);
insert into PracticeAttendance (practice_id, player_id)
values (13, 15);
insert into PracticeAttendance (practice_id, player_id)
values (28, 20);
insert into PracticeAttendance (practice_id, player_id)
values (52, 12);
insert into PracticeAttendance (practice_id, player_id)
values (31, 60);
insert into PracticeAttendance (practice_id, player_id)
values (16, 36);
insert into PracticeAttendance (practice_id, player_id)
values (17, 1);
insert into PracticeAttendance (practice_id, player_id)
values (4, 7);
insert into PracticeAttendance (practice_id, player_id)
values (9, 28);
insert into PracticeAttendance (practice_id, player_id)
values (6, 52);
insert into PracticeAttendance (practice_id, player_id)
values (50, 37);
insert into PracticeAttendance (practice_id, player_id)
values (3, 55);
insert into PracticeAttendance (practice_id, player_id)
values (32, 43);
insert into PracticeAttendance (practice_id, player_id)
values (46, 14);
insert into PracticeAttendance (practice_id, player_id)
values (39, 25);
insert into PracticeAttendance (practice_id, player_id)
values (57, 42);
insert into PracticeAttendance (practice_id, player_id)
values (15, 46);
insert into PracticeAttendance (practice_id, player_id)
values (10, 31);
insert into PracticeAttendance (practice_id, player_id)
values (37, 9);
insert into PracticeAttendance (practice_id, player_id)
values (5, 47);
insert into PracticeAttendance (practice_id, player_id)
values (30, 56);
insert into PracticeAttendance (practice_id, player_id)
values (14, 26);
insert into PracticeAttendance (practice_id, player_id)
values (23, 49);
insert into PracticeAttendance (practice_id, player_id)
values (12, 8);
insert into PracticeAttendance (practice_id, player_id)
values (54, 5);
insert into PracticeAttendance (practice_id, player_id)
values (35, 19);
insert into PracticeAttendance (practice_id, player_id)
values (43, 51);
insert into PracticeAttendance (practice_id, player_id)
values (59, 30);
insert into PracticeAttendance (practice_id, player_id)
values (27, 34);
insert into PracticeAttendance (practice_id, player_id)
values (21, 25);
insert into PracticeAttendance (practice_id, player_id)
values (43, 17);
insert into PracticeAttendance (practice_id, player_id)
values (19, 30);
insert into PracticeAttendance (practice_id, player_id)
values (21, 57);
insert into PracticeAttendance (practice_id, player_id)
values (9, 7);
insert into PracticeAttendance (practice_id, player_id)
values (16, 54);
insert into PracticeAttendance (practice_id, player_id)
values (41, 13);
insert into PracticeAttendance (practice_id, player_id)
values (49, 50);
insert into PracticeAttendance (practice_id, player_id)
values (1, 56);
insert into PracticeAttendance (practice_id, player_id)
values (32, 18);
insert into PracticeAttendance (practice_id, player_id)
values (15, 58);
insert into PracticeAttendance (practice_id, player_id)
values (14, 40);
insert into PracticeAttendance (practice_id, player_id)
values (47, 38);
insert into PracticeAttendance (practice_id, player_id)
values (24, 2);
insert into PracticeAttendance (practice_id, player_id)
values (35, 10);
insert into PracticeAttendance (practice_id, player_id)
values (54, 16);
insert into PracticeAttendance (practice_id, player_id)
values (25, 27);
insert into PracticeAttendance (practice_id, player_id)
values (12, 37);
insert into PracticeAttendance (practice_id, player_id)
values (36, 23);
insert into PracticeAttendance (practice_id, player_id)
values (18, 43);
insert into PracticeAttendance (practice_id, player_id)
values (42, 20);

insert into GameCoaches (coach_id, game_id)
values (7, 57);
insert into GameCoaches (coach_id, game_id)
values (40, 47);
insert into GameCoaches (coach_id, game_id)
values (30, 2);
insert into GameCoaches (coach_id, game_id)
values (16, 30);
insert into GameCoaches (coach_id, game_id)
values (48, 8);
insert into GameCoaches (coach_id, game_id)
values (13, 13);
insert into GameCoaches (coach_id, game_id)
values (5, 14);
insert into GameCoaches (coach_id, game_id)
values (44, 46);
insert into GameCoaches (coach_id, game_id)
values (33, 16);
insert into GameCoaches (coach_id, game_id)
values (33, 7);
insert into GameCoaches (coach_id, game_id)
values (39, 4);
insert into GameCoaches (coach_id, game_id)
values (55, 23);
insert into GameCoaches (coach_id, game_id)
values (11, 6);
insert into GameCoaches (coach_id, game_id)
values (43, 28);
insert into GameCoaches (coach_id, game_id)
values (52, 34);
insert into GameCoaches (coach_id, game_id)
values (27, 9);
insert into GameCoaches (coach_id, game_id)
values (55, 45);
insert into GameCoaches (coach_id, game_id)
values (3, 29);
insert into GameCoaches (coach_id, game_id)
values (58, 48);
insert into GameCoaches (coach_id, game_id)
values (6, 12);
insert into GameCoaches (coach_id, game_id)
values (4, 60);
insert into GameCoaches (coach_id, game_id)
values (15, 11);
insert into GameCoaches (coach_id, game_id)
values (7, 10);
insert into GameCoaches (coach_id, game_id)
values (6, 18);
insert into GameCoaches (coach_id, game_id)
values (51, 50);
insert into GameCoaches (coach_id, game_id)
values (17, 51);
insert into GameCoaches (coach_id, game_id)
values (9, 54);
insert into GameCoaches (coach_id, game_id)
values (53, 21);
insert into GameCoaches (coach_id, game_id)
values (28, 25);
insert into GameCoaches (coach_id, game_id)
values (5, 3);
insert into GameCoaches (coach_id, game_id)
values (37, 27);
insert into GameCoaches (coach_id, game_id)
values (18, 33);
insert into GameCoaches (coach_id, game_id)
values (49, 5);
insert into GameCoaches (coach_id, game_id)
values (22, 26);
insert into GameCoaches (coach_id, game_id)
values (38, 20);
insert into GameCoaches (coach_id, game_id)
values (2, 40);
insert into GameCoaches (coach_id, game_id)
values (32, 59);
insert into GameCoaches (coach_id, game_id)
values (13, 39);
insert into GameCoaches (coach_id, game_id)
values (4, 36);
insert into GameCoaches (coach_id, game_id)
values (22, 1);
insert into GameCoaches (coach_id, game_id)
values (55, 44);
insert into GameCoaches (coach_id, game_id)
values (35, 38);
insert into GameCoaches (coach_id, game_id)
values (9, 41);
insert into GameCoaches (coach_id, game_id)
values (58, 15);
insert into GameCoaches (coach_id, game_id)
values (53, 53);
insert into GameCoaches (coach_id, game_id)
values (27, 42);
insert into GameCoaches (coach_id, game_id)
values (37, 24);
insert into GameCoaches (coach_id, game_id)
values (26, 17);
insert into GameCoaches (coach_id, game_id)
values (33, 43);
insert into GameCoaches (coach_id, game_id)
values (54, 19);
insert into GameCoaches (coach_id, game_id)
values (29, 35);
insert into GameCoaches (coach_id, game_id)
values (34, 37);
insert into GameCoaches (coach_id, game_id)
values (44, 32);
insert into GameCoaches (coach_id, game_id)
values (60, 55);
insert into GameCoaches (coach_id, game_id)
values (25, 22);
insert into GameCoaches (coach_id, game_id)
values (14, 31);
insert into GameCoaches (coach_id, game_id)
values (9, 52);
insert into GameCoaches (coach_id, game_id)
values (22, 56);
insert into GameCoaches (coach_id, game_id)
values (17, 58);
insert into GameCoaches (coach_id, game_id)
values (38, 49);
insert into GameCoaches (coach_id, game_id)
values (23, 54);
insert into GameCoaches (coach_id, game_id)
values (49, 29);
insert into GameCoaches (coach_id, game_id)
values (12, 6);
insert into GameCoaches (coach_id, game_id)
values (23, 39);
insert into GameCoaches (coach_id, game_id)
values (10, 56);
insert into GameCoaches (coach_id, game_id)
values (26, 31);
insert into GameCoaches (coach_id, game_id)
values (47, 24);
insert into GameCoaches (coach_id, game_id)
values (12, 17);
insert into GameCoaches (coach_id, game_id)
values (54, 22);
insert into GameCoaches (coach_id, game_id)
values (59, 13);
insert into GameCoaches (coach_id, game_id)
values (50, 1);
insert into GameCoaches (coach_id, game_id)
values (38, 38);
insert into GameCoaches (coach_id, game_id)
values (51, 10);
insert into GameCoaches (coach_id, game_id)
values (47, 14);
insert into GameCoaches (coach_id, game_id)
values (43, 9);
insert into GameCoaches (coach_id, game_id)
values (57, 55);
insert into GameCoaches (coach_id, game_id)
values (36, 20);
insert into GameCoaches (coach_id, game_id)
values (47, 47);
insert into GameCoaches (coach_id, game_id)
values (51, 3);
insert into GameCoaches (coach_id, game_id)
values (24, 58);
insert into GameCoaches (coach_id, game_id)
values (31, 35);
insert into GameCoaches (coach_id, game_id)
values (45, 46);
insert into GameCoaches (coach_id, game_id)
values (5, 49);
insert into GameCoaches (coach_id, game_id)
values (60, 43);
insert into GameCoaches (coach_id, game_id)
values (14, 11);
insert into GameCoaches (coach_id, game_id)
values (45, 18);
insert into GameCoaches (coach_id, game_id)
values (58, 45);
insert into GameCoaches (coach_id, game_id)
values (51, 28);
insert into GameCoaches (coach_id, game_id)
values (57, 36);
insert into GameCoaches (coach_id, game_id)
values (53, 27);
insert into GameCoaches (coach_id, game_id)
values (24, 16);
insert into GameCoaches (coach_id, game_id)
values (29, 25);
insert into GameCoaches (coach_id, game_id)
values (35, 40);
insert into GameCoaches (coach_id, game_id)
values (37, 33);
insert into GameCoaches (coach_id, game_id)
values (53, 26);
insert into GameCoaches (coach_id, game_id)
values (34, 5);
insert into GameCoaches (coach_id, game_id)
values (1, 53);
insert into GameCoaches (coach_id, game_id)
values (47, 21);
insert into GameCoaches (coach_id, game_id)
values (45, 60);
insert into GameCoaches (coach_id, game_id)
values (8, 59);
insert into GameCoaches (coach_id, game_id)
values (59, 30);
insert into GameCoaches (coach_id, game_id)
values (19, 19);
insert into GameCoaches (coach_id, game_id)
values (9, 34);
insert into GameCoaches (coach_id, game_id)
values (26, 51);
insert into GameCoaches (coach_id, game_id)
values (3, 57);
insert into GameCoaches (coach_id, game_id)
values (9, 8);
insert into GameCoaches (coach_id, game_id)
values (17, 2);
insert into GameCoaches (coach_id, game_id)
values (38, 23);
insert into GameCoaches (coach_id, game_id)
values (48, 50);
insert into GameCoaches (coach_id, game_id)
values (48, 44);
insert into GameCoaches (coach_id, game_id)
values (60, 15);
insert into GameCoaches (coach_id, game_id)
values (11, 4);
insert into GameCoaches (coach_id, game_id)
values (21, 41);
insert into GameCoaches (coach_id, game_id)
values (6, 37);
insert into GameCoaches (coach_id, game_id)
values (60, 12);
insert into GameCoaches (coach_id, game_id)
values (46, 48);
insert into GameCoaches (coach_id, game_id)
values (10, 32);
insert into GameCoaches (coach_id, game_id)
values (37, 52);
insert into GameCoaches (coach_id, game_id)
values (31, 42);
insert into GameCoaches (coach_id, game_id)
values (23, 7);
insert into GameCoaches (coach_id, game_id)
values (36, 10);
insert into GameCoaches (coach_id, game_id)
values (9, 4);
insert into GameCoaches (coach_id, game_id)
values (9, 50);
insert into GameCoaches (coach_id, game_id)
values (14, 30);
insert into GameCoaches (coach_id, game_id)
values (39, 55);
insert into GameCoaches (coach_id, game_id)
values (23, 35);
insert into GameCoaches (coach_id, game_id)
values (16, 40);
insert into GameCoaches (coach_id, game_id)
values (22, 14);
insert into GameCoaches (coach_id, game_id)
values (47, 6);
insert into GameCoaches (coach_id, game_id)
values (13, 29);
insert into GameCoaches (coach_id, game_id)
values (18, 22);
insert into GameCoaches (coach_id, game_id)
values (26, 5);
insert into GameCoaches (coach_id, game_id)
values (20, 52);
insert into GameCoaches (coach_id, game_id)
values (46, 2);
insert into GameCoaches (coach_id, game_id)
values (10, 12);
insert into GameCoaches (coach_id, game_id)
values (57, 42);
insert into GameCoaches (coach_id, game_id)
values (51, 18);
insert into GameCoaches (coach_id, game_id)
values (36, 45);
insert into GameCoaches (coach_id, game_id)
values (30, 24);
insert into GameCoaches (coach_id, game_id)
values (29, 7);
insert into GameCoaches (coach_id, game_id)
values (36, 17);
insert into GameCoaches (coach_id, game_id)
values (24, 39);
insert into GameCoaches (coach_id, game_id)
values (59, 28);
insert into GameCoaches (coach_id, game_id)
values (15, 43);
insert into GameCoaches (coach_id, game_id)
values (27, 31);
insert into GameCoaches (coach_id, game_id)
values (27, 38);
insert into GameCoaches (coach_id, game_id)
values (58, 21);
insert into GameCoaches (coach_id, game_id)
values (13, 48);
insert into GameCoaches (coach_id, game_id)
values (7, 54);
insert into GameCoaches (coach_id, game_id)
values (58, 44);
insert into GameCoaches (coach_id, game_id)
values (16, 59);
insert into GameCoaches (coach_id, game_id)
values (40, 8);
insert into GameCoaches (coach_id, game_id)
values (54, 26);
insert into GameCoaches (coach_id, game_id)
values (4, 13);
insert into GameCoaches (coach_id, game_id)
values (42, 53);
insert into GameCoaches (coach_id, game_id)
values (53, 3);
insert into GameCoaches (coach_id, game_id)
values (43, 41);
insert into GameCoaches (coach_id, game_id)
values (30, 27);
insert into GameCoaches (coach_id, game_id)
values (10, 34);
insert into GameCoaches (coach_id, game_id)
values (42, 60);
insert into GameCoaches (coach_id, game_id)
values (3, 9);
insert into GameCoaches (coach_id, game_id)
values (52, 20);
insert into GameCoaches (coach_id, game_id)
values (47, 1);
insert into GameCoaches (coach_id, game_id)
values (23, 57);
insert into GameCoaches (coach_id, game_id)
values (25, 36);
insert into GameCoaches (coach_id, game_id)
values (41, 58);
insert into GameCoaches (coach_id, game_id)
values (33, 23);
insert into GameCoaches (coach_id, game_id)
values (22, 19);
insert into GameCoaches (coach_id, game_id)
values (54, 33);
insert into GameCoaches (coach_id, game_id)
values (22, 49);
insert into GameCoaches (coach_id, game_id)
values (58, 11);
insert into GameCoaches (coach_id, game_id)
values (5, 37);
insert into GameCoaches (coach_id, game_id)
values (10, 57);
insert into GameCoaches (coach_id, game_id)
values (16, 32);
insert into GameCoaches (coach_id, game_id)
values (45, 51);
insert into GameCoaches (coach_id, game_id)
values (28, 16);
insert into GameCoaches (coach_id, game_id)
values (2, 15);
insert into GameCoaches (coach_id, game_id)
values (21, 25);
insert into GameCoaches (coach_id, game_id)
values (28, 46);
insert into GameCoaches (coach_id, game_id)
values (4, 47);
insert into GameCoaches (coach_id, game_id)
values (19, 46);
insert into GameCoaches (coach_id, game_id)
values (17, 40);
insert into GameCoaches (coach_id, game_id)
values (38, 25);
insert into GameCoaches (coach_id, game_id)
values (40, 1);
insert into GameCoaches (coach_id, game_id)
values (34, 27);
insert into GameCoaches (coach_id, game_id)
values (53, 35);
insert into GameCoaches (coach_id, game_id)
values (39, 26);
insert into GameCoaches (coach_id, game_id)
values (29, 3);
insert into GameCoaches (coach_id, game_id)
values (21, 59);
insert into GameCoaches (coach_id, game_id)
values (6, 2);
insert into GameCoaches (coach_id, game_id)
values (23, 10);
insert into GameCoaches (coach_id, game_id)
values (40, 29);
insert into GameCoaches (coach_id, game_id)
values (31, 8);
insert into GameCoaches (coach_id, game_id)
values (55, 24);
insert into GameCoaches (coach_id, game_id)
values (34, 43);
insert into GameCoaches (coach_id, game_id)
values (58, 51);
insert into GameCoaches (coach_id, game_id)
values (20, 58);
insert into GameCoaches (coach_id, game_id)
values (2, 31);
insert into GameCoaches (coach_id, game_id)
values (38, 21);
insert into GameCoaches (coach_id, game_id)
values (45, 4);

insert into TeamGames (team_id, game_id)
values (38, 9);
insert into TeamGames (team_id, game_id)
values (32, 47);
insert into TeamGames (team_id, game_id)
values (30, 52);
insert into TeamGames (team_id, game_id)
values (31, 45);
insert into TeamGames (team_id, game_id)
values (20, 16);
insert into TeamGames (team_id, game_id)
values (14, 13);
insert into TeamGames (team_id, game_id)
values (18, 15);
insert into TeamGames (team_id, game_id)
values (48, 7);
insert into TeamGames (team_id, game_id)
values (45, 56);
insert into TeamGames (team_id, game_id)
values (52, 20);
insert into TeamGames (team_id, game_id)
values (36, 25);
insert into TeamGames (team_id, game_id)
values (25, 54);
insert into TeamGames (team_id, game_id)
values (21, 21);
insert into TeamGames (team_id, game_id)
values (12, 36);
insert into TeamGames (team_id, game_id)
values (58, 48);
insert into TeamGames (team_id, game_id)
values (27, 19);
insert into TeamGames (team_id, game_id)
values (23, 60);
insert into TeamGames (team_id, game_id)
values (57, 6);
insert into TeamGames (team_id, game_id)
values (1, 58);
insert into TeamGames (team_id, game_id)
values (15, 27);
insert into TeamGames (team_id, game_id)
values (53, 10);
insert into TeamGames (team_id, game_id)
values (9, 8);
insert into TeamGames (team_id, game_id)
values (42, 24);
insert into TeamGames (team_id, game_id)
values (37, 17);
insert into TeamGames (team_id, game_id)
values (35, 12);
insert into TeamGames (team_id, game_id)
values (10, 53);
insert into TeamGames (team_id, game_id)
values (17, 33);
insert into TeamGames (team_id, game_id)
values (7, 3);
insert into TeamGames (team_id, game_id)
values (59, 31);
insert into TeamGames (team_id, game_id)
values (60, 57);
insert into TeamGames (team_id, game_id)
values (33, 50);
insert into TeamGames (team_id, game_id)
values (56, 39);
insert into TeamGames (team_id, game_id)
values (47, 30);
insert into TeamGames (team_id, game_id)
values (26, 43);
insert into TeamGames (team_id, game_id)
values (2, 51);
insert into TeamGames (team_id, game_id)
values (16, 28);
insert into TeamGames (team_id, game_id)
values (46, 22);
insert into TeamGames (team_id, game_id)
values (39, 2);
insert into TeamGames (team_id, game_id)
values (40, 55);
insert into TeamGames (team_id, game_id)
values (55, 44);
insert into TeamGames (team_id, game_id)
values (8, 23);
insert into TeamGames (team_id, game_id)
values (54, 42);
insert into TeamGames (team_id, game_id)
values (19, 1);
insert into TeamGames (team_id, game_id)
values (24, 40);
insert into TeamGames (team_id, game_id)
values (49, 14);
insert into TeamGames (team_id, game_id)
values (41, 41);
insert into TeamGames (team_id, game_id)
values (11, 4);
insert into TeamGames (team_id, game_id)
values (13, 18);
insert into TeamGames (team_id, game_id)
values (5, 35);
insert into TeamGames (team_id, game_id)
values (3, 34);
insert into TeamGames (team_id, game_id)
values (51, 5);
insert into TeamGames (team_id, game_id)
values (28, 37);
insert into TeamGames (team_id, game_id)
values (29, 29);
insert into TeamGames (team_id, game_id)
values (43, 11);
insert into TeamGames (team_id, game_id)
values (34, 59);
insert into TeamGames (team_id, game_id)
values (4, 32);
insert into TeamGames (team_id, game_id)
values (50, 38);
insert into TeamGames (team_id, game_id)
values (22, 26);
insert into TeamGames (team_id, game_id)
values (44, 46);
insert into TeamGames (team_id, game_id)
values (6, 49);
insert into TeamGames (team_id, game_id)
values (36, 48);
insert into TeamGames (team_id, game_id)
values (45, 26);
insert into TeamGames (team_id, game_id)
values (4, 36);
insert into TeamGames (team_id, game_id)
values (40, 6);
insert into TeamGames (team_id, game_id)
values (7, 53);
insert into TeamGames (team_id, game_id)
values (37, 23);
insert into TeamGames (team_id, game_id)
values (55, 3);
insert into TeamGames (team_id, game_id)
values (56, 56);
insert into TeamGames (team_id, game_id)
values (58, 47);
insert into TeamGames (team_id, game_id)
values (54, 38);
insert into TeamGames (team_id, game_id)
values (32, 39);
insert into TeamGames (team_id, game_id)
values (57, 18);
insert into TeamGames (team_id, game_id)
values (27, 9);
insert into TeamGames (team_id, game_id)
values (13, 21);
insert into TeamGames (team_id, game_id)
values (33, 40);
insert into TeamGames (team_id, game_id)
values (24, 57);
insert into TeamGames (team_id, game_id)
values (39, 1);
insert into TeamGames (team_id, game_id)
values (3, 42);
insert into TeamGames (team_id, game_id)
values (60, 44);
insert into TeamGames (team_id, game_id)
values (12, 29);
insert into TeamGames (team_id, game_id)
values (1, 60);
insert into TeamGames (team_id, game_id)
values (30, 54);
insert into TeamGames (team_id, game_id)
values (48, 35);
insert into TeamGames (team_id, game_id)
values (42, 12);
insert into TeamGames (team_id, game_id)
values (21, 5);
insert into TeamGames (team_id, game_id)
values (10, 31);
insert into TeamGames (team_id, game_id)
values (14, 2);
insert into TeamGames (team_id, game_id)
values (49, 10);
insert into TeamGames (team_id, game_id)
values (15, 33);
insert into TeamGames (team_id, game_id)
values (26, 58);
insert into TeamGames (team_id, game_id)
values (44, 22);
insert into TeamGames (team_id, game_id)
values (8, 45);
insert into TeamGames (team_id, game_id)
values (35, 43);
insert into TeamGames (team_id, game_id)
values (34, 27);
insert into TeamGames (team_id, game_id)
values (9, 9);
insert into TeamGames (team_id, game_id)
values (28, 25);
insert into TeamGames (team_id, game_id)
values (19, 41);
insert into TeamGames (team_id, game_id)
values (25, 52);
insert into TeamGames (team_id, game_id)
values (31, 17);
insert into TeamGames (team_id, game_id)
values (11, 5);
insert into TeamGames (team_id, game_id)
values (17, 46);
insert into TeamGames (team_id, game_id)
values (46, 20);
insert into TeamGames (team_id, game_id)
values (2, 49);
insert into TeamGames (team_id, game_id)
values (41, 55);
insert into TeamGames (team_id, game_id)
values (5, 28);
insert into TeamGames (team_id, game_id)
values (38, 32);
insert into TeamGames (team_id, game_id)
values (53, 14);
insert into TeamGames (team_id, game_id)
values (16, 19);
insert into TeamGames (team_id, game_id)
values (47, 34);
insert into TeamGames (team_id, game_id)
values (29, 51);
insert into TeamGames (team_id, game_id)
values (43, 12);
insert into TeamGames (team_id, game_id)
values (18, 24);
insert into TeamGames (team_id, game_id)
values (20, 50);
insert into TeamGames (team_id, game_id)
values (23, 13);
insert into TeamGames (team_id, game_id)
values (22, 59);
insert into TeamGames (team_id, game_id)
values (50, 7);
insert into TeamGames (team_id, game_id)
values (59, 15);
insert into TeamGames (team_id, game_id)
values (52, 16);
insert into TeamGames (team_id, game_id)
values (51, 37);
insert into TeamGames (team_id, game_id)
values (6, 30);
insert into TeamGames (team_id, game_id)
values (3, 22);
insert into TeamGames (team_id, game_id)
values (20, 27);
insert into TeamGames (team_id, game_id)
values (32, 3);
insert into TeamGames (team_id, game_id)
values (22, 31);
insert into TeamGames (team_id, game_id)
values (52, 18);
insert into TeamGames (team_id, game_id)
values (2, 40);
insert into TeamGames (team_id, game_id)
values (39, 19);
insert into TeamGames (team_id, game_id)
values (9, 53);
insert into TeamGames (team_id, game_id)
values (57, 15);
insert into TeamGames (team_id, game_id)
values (37, 4);
insert into TeamGames (team_id, game_id)
values (5, 45);
insert into TeamGames (team_id, game_id)
values (38, 39);
insert into TeamGames (team_id, game_id)
values (24, 30);
insert into TeamGames (team_id, game_id)
values (46, 60);
insert into TeamGames (team_id, game_id)
values (16, 21);
insert into TeamGames (team_id, game_id)
values (17, 54);
insert into TeamGames (team_id, game_id)
values (41, 34);
insert into TeamGames (team_id, game_id)
values (26, 28);
insert into TeamGames (team_id, game_id)
values (31, 23);
insert into TeamGames (team_id, game_id)
values (48, 52);
insert into TeamGames (team_id, game_id)
values (56, 2);
insert into TeamGames (team_id, game_id)
values (50, 8);
insert into TeamGames (team_id, game_id)
values (27, 32);
insert into TeamGames (team_id, game_id)
values (11, 55);
insert into TeamGames (team_id, game_id)
values (15, 1);
insert into TeamGames (team_id, game_id)
values (35, 36);
insert into TeamGames (team_id, game_id)
values (34, 57);
insert into TeamGames (team_id, game_id)
values (10, 9);
insert into TeamGames (team_id, game_id)
values (33, 35);
insert into TeamGames (team_id, game_id)
values (44, 42);
insert into TeamGames (team_id, game_id)
values (4, 14);
insert into TeamGames (team_id, game_id)
values (14, 38);
insert into TeamGames (team_id, game_id)
values (40, 7);
insert into TeamGames (team_id, game_id)
values (60, 16);
insert into TeamGames (team_id, game_id)
values (51, 56);
insert into TeamGames (team_id, game_id)
values (19, 25);
insert into TeamGames (team_id, game_id)
values (55, 29);
insert into TeamGames (team_id, game_id)
values (36, 17);
insert into TeamGames (team_id, game_id)
values (6, 58);
insert into TeamGames (team_id, game_id)
values (18, 26);
insert into TeamGames (team_id, game_id)
values (43, 37);
insert into TeamGames (team_id, game_id)
values (30, 44);
insert into TeamGames (team_id, game_id)
values (8, 48);
insert into TeamGames (team_id, game_id)
values (59, 5);
insert into TeamGames (team_id, game_id)
values (49, 24);
insert into TeamGames (team_id, game_id)
values (42, 6);
insert into TeamGames (team_id, game_id)
values (47, 11);
insert into TeamGames (team_id, game_id)
values (7, 20);
insert into TeamGames (team_id, game_id)
values (23, 59);
insert into TeamGames (team_id, game_id)
values (13, 47);
insert into TeamGames (team_id, game_id)
values (12, 50);
insert into TeamGames (team_id, game_id)
values (28, 10);
insert into TeamGames (team_id, game_id)
values (21, 46);
insert into TeamGames (team_id, game_id)
values (29, 52);
insert into TeamGames (team_id, game_id)
values (53, 33);
insert into TeamGames (team_id, game_id)
values (58, 49);
insert into TeamGames (team_id, game_id)
values (45, 43);
insert into TeamGames (team_id, game_id)
values (54, 13);
insert into TeamGames (team_id, game_id)
values (1, 41);
insert into TeamGames (team_id, game_id)
values (25, 12);
insert into TeamGames (team_id, game_id)
values (34, 22);
insert into TeamGames (team_id, game_id)
values (51, 50);
insert into TeamGames (team_id, game_id)
values (17, 48);
insert into TeamGames (team_id, game_id)
values (56, 57);
insert into TeamGames (team_id, game_id)
values (32, 19);
insert into TeamGames (team_id, game_id)
values (3, 15);
insert into TeamGames (team_id, game_id)
values (27, 2);
insert into TeamGames (team_id, game_id)
values (60, 58);
insert into TeamGames (team_id, game_id)
values (23, 10);
insert into TeamGames (team_id, game_id)
values (30, 45);
insert into TeamGames (team_id, game_id)
values (40, 49);
insert into TeamGames (team_id, game_id)
values (57, 38);
insert into TeamGames (team_id, game_id)
values (9, 52);
insert into TeamGames (team_id, game_id)
values (46, 46);
insert into TeamGames (team_id, game_id)
values (22, 5);
insert into TeamGames (team_id, game_id)
values (52, 33);
insert into TeamGames (team_id, game_id)
values (15, 25);
insert into TeamGames (team_id, game_id)
values (8, 18);
insert into TeamGames (team_id, game_id)
values (31, 20);
insert into TeamGames (team_id, game_id)
values (29, 41);

insert into TeamPractices (team_id, practice_id)
values (7, 5);
insert into TeamPractices (team_id, practice_id)
values (32, 43);
insert into TeamPractices (team_id, practice_id)
values (2, 9);
insert into TeamPractices (team_id, practice_id)
values (23, 30);
insert into TeamPractices (team_id, practice_id)
values (33, 24);
insert into TeamPractices (team_id, practice_id)
values (51, 32);
insert into TeamPractices (team_id, practice_id)
values (35, 45);
insert into TeamPractices (team_id, practice_id)
values (45, 49);
insert into TeamPractices (team_id, practice_id)
values (30, 51);
insert into TeamPractices (team_id, practice_id)
values (3, 39);
insert into TeamPractices (team_id, practice_id)
values (4, 42);
insert into TeamPractices (team_id, practice_id)
values (34, 25);
insert into TeamPractices (team_id, practice_id)
values (24, 44);
insert into TeamPractices (team_id, practice_id)
values (42, 29);
insert into TeamPractices (team_id, practice_id)
values (29, 20);
insert into TeamPractices (team_id, practice_id)
values (52, 4);
insert into TeamPractices (team_id, practice_id)
values (57, 12);
insert into TeamPractices (team_id, practice_id)
values (46, 6);
insert into TeamPractices (team_id, practice_id)
values (60, 8);
insert into TeamPractices (team_id, practice_id)
values (56, 18);
insert into TeamPractices (team_id, practice_id)
values (9, 57);
insert into TeamPractices (team_id, practice_id)
values (28, 22);
insert into TeamPractices (team_id, practice_id)
values (49, 3);
insert into TeamPractices (team_id, practice_id)
values (31, 38);
insert into TeamPractices (team_id, practice_id)
values (47, 31);
insert into TeamPractices (team_id, practice_id)
values (13, 15);
insert into TeamPractices (team_id, practice_id)
values (37, 28);
insert into TeamPractices (team_id, practice_id)
values (38, 10);
insert into TeamPractices (team_id, practice_id)
values (10, 26);
insert into TeamPractices (team_id, practice_id)
values (14, 40);
insert into TeamPractices (team_id, practice_id)
values (48, 48);
insert into TeamPractices (team_id, practice_id)
values (55, 13);
insert into TeamPractices (team_id, practice_id)
values (58, 54);
insert into TeamPractices (team_id, practice_id)
values (8, 1);
insert into TeamPractices (team_id, practice_id)
values (1, 46);
insert into TeamPractices (team_id, practice_id)
values (39, 56);
insert into TeamPractices (team_id, practice_id)
values (19, 59);
insert into TeamPractices (team_id, practice_id)
values (25, 58);
insert into TeamPractices (team_id, practice_id)
values (59, 21);
insert into TeamPractices (team_id, practice_id)
values (41, 23);
insert into TeamPractices (team_id, practice_id)
values (36, 17);
insert into TeamPractices (team_id, practice_id)
values (27, 2);
insert into TeamPractices (team_id, practice_id)
values (5, 34);
insert into TeamPractices (team_id, practice_id)
values (53, 41);
insert into TeamPractices (team_id, practice_id)
values (44, 33);
insert into TeamPractices (team_id, practice_id)
values (17, 60);
insert into TeamPractices (team_id, practice_id)
values (26, 27);
insert into TeamPractices (team_id, practice_id)
values (20, 50);
insert into TeamPractices (team_id, practice_id)
values (22, 14);
insert into TeamPractices (team_id, practice_id)
values (6, 55);
insert into TeamPractices (team_id, practice_id)
values (11, 11);
insert into TeamPractices (team_id, practice_id)
values (54, 36);
insert into TeamPractices (team_id, practice_id)
values (18, 19);
insert into TeamPractices (team_id, practice_id)
values (16, 52);
insert into TeamPractices (team_id, practice_id)
values (43, 16);
insert into TeamPractices (team_id, practice_id)
values (21, 35);
insert into TeamPractices (team_id, practice_id)
values (15, 37);
insert into TeamPractices (team_id, practice_id)
values (50, 47);
insert into TeamPractices (team_id, practice_id)
values (12, 7);
insert into TeamPractices (team_id, practice_id)
values (40, 53);
insert into TeamPractices (team_id, practice_id)
values (27, 56);
insert into TeamPractices (team_id, practice_id)
values (28, 60);
insert into TeamPractices (team_id, practice_id)
values (50, 27);
insert into TeamPractices (team_id, practice_id)
values (30, 1);
insert into TeamPractices (team_id, practice_id)
values (37, 40);
insert into TeamPractices (team_id, practice_id)
values (18, 49);
insert into TeamPractices (team_id, practice_id)
values (25, 3);
insert into TeamPractices (team_id, practice_id)
values (2, 19);
insert into TeamPractices (team_id, practice_id)
values (6, 6);
insert into TeamPractices (team_id, practice_id)
values (49, 59);
insert into TeamPractices (team_id, practice_id)
values (10, 23);
insert into TeamPractices (team_id, practice_id)
values (35, 16);
insert into TeamPractices (team_id, practice_id)
values (16, 18);
insert into TeamPractices (team_id, practice_id)
values (9, 52);
insert into TeamPractices (team_id, practice_id)
values (17, 36);
insert into TeamPractices (team_id, practice_id)
values (48, 30);
insert into TeamPractices (team_id, practice_id)
values (14, 5);
insert into TeamPractices (team_id, practice_id)
values (5, 28);
insert into TeamPractices (team_id, practice_id)
values (45, 17);
insert into TeamPractices (team_id, practice_id)
values (58, 35);
insert into TeamPractices (team_id, practice_id)
values (36, 46);
insert into TeamPractices (team_id, practice_id)
values (53, 47);
insert into TeamPractices (team_id, practice_id)
values (54, 8);
insert into TeamPractices (team_id, practice_id)
values (46, 4);
insert into TeamPractices (team_id, practice_id)
values (51, 29);
insert into TeamPractices (team_id, practice_id)
values (24, 42);
insert into TeamPractices (team_id, practice_id)
values (26, 14);
insert into TeamPractices (team_id, practice_id)
values (41, 25);
insert into TeamPractices (team_id, practice_id)
values (8, 13);
insert into TeamPractices (team_id, practice_id)
values (47, 54);
insert into TeamPractices (team_id, practice_id)
values (13, 26);
insert into TeamPractices (team_id, practice_id)
values (56, 55);
insert into TeamPractices (team_id, practice_id)
values (20, 21);
insert into TeamPractices (team_id, practice_id)
values (3, 12);
insert into TeamPractices (team_id, practice_id)
values (22, 44);
insert into TeamPractices (team_id, practice_id)
values (11, 48);
insert into TeamPractices (team_id, practice_id)
values (60, 57);
insert into TeamPractices (team_id, practice_id)
values (29, 24);
insert into TeamPractices (team_id, practice_id)
values (31, 11);
insert into TeamPractices (team_id, practice_id)
values (7, 15);
insert into TeamPractices (team_id, practice_id)
values (34, 39);
insert into TeamPractices (team_id, practice_id)
values (59, 34);
insert into TeamPractices (team_id, practice_id)
values (44, 9);
insert into TeamPractices (team_id, practice_id)
values (57, 50);
insert into TeamPractices (team_id, practice_id)
values (1, 20);
insert into TeamPractices (team_id, practice_id)
values (4, 53);
insert into TeamPractices (team_id, practice_id)
values (55, 37);
insert into TeamPractices (team_id, practice_id)
values (40, 32);
insert into TeamPractices (team_id, practice_id)
values (12, 51);
insert into TeamPractices (team_id, practice_id)
values (33, 58);
insert into TeamPractices (team_id, practice_id)
values (43, 38);
insert into TeamPractices (team_id, practice_id)
values (23, 7);
insert into TeamPractices (team_id, practice_id)
values (15, 41);
insert into TeamPractices (team_id, practice_id)
values (52, 31);
insert into TeamPractices (team_id, practice_id)
values (42, 45);
insert into TeamPractices (team_id, practice_id)
values (19, 2);
insert into TeamPractices (team_id, practice_id)
values (21, 10);
insert into TeamPractices (team_id, practice_id)
values (38, 43);
insert into TeamPractices (team_id, practice_id)
values (39, 22);
insert into TeamPractices (team_id, practice_id)
values (32, 33);
insert into TeamPractices (team_id, practice_id)
values (16, 2);
insert into TeamPractices (team_id, practice_id)
values (40, 52);
insert into TeamPractices (team_id, practice_id)
values (5, 41);
insert into TeamPractices (team_id, practice_id)
values (39, 3);
insert into TeamPractices (team_id, practice_id)
values (41, 12);
insert into TeamPractices (team_id, practice_id)
values (28, 51);
insert into TeamPractices (team_id, practice_id)
values (14, 32);
insert into TeamPractices (team_id, practice_id)
values (58, 56);
insert into TeamPractices (team_id, practice_id)
values (48, 53);
insert into TeamPractices (team_id, practice_id)
values (36, 37);
insert into TeamPractices (team_id, practice_id)
values (21, 6);
insert into TeamPractices (team_id, practice_id)
values (33, 46);
insert into TeamPractices (team_id, practice_id)
values (60, 24);
insert into TeamPractices (team_id, practice_id)
values (17, 9);
insert into TeamPractices (team_id, practice_id)
values (55, 26);
insert into TeamPractices (team_id, practice_id)
values (43, 43);
insert into TeamPractices (team_id, practice_id)
values (37, 54);
insert into TeamPractices (team_id, practice_id)
values (47, 36);
insert into TeamPractices (team_id, practice_id)
values (35, 23);
insert into TeamPractices (team_id, practice_id)
values (53, 49);
insert into TeamPractices (team_id, practice_id)
values (11, 58);
insert into TeamPractices (team_id, practice_id)
values (22, 1);
insert into TeamPractices (team_id, practice_id)
values (10, 16);
insert into TeamPractices (team_id, practice_id)
values (19, 57);
insert into TeamPractices (team_id, practice_id)
values (27, 44);
insert into TeamPractices (team_id, practice_id)
values (4, 45);
insert into TeamPractices (team_id, practice_id)
values (8, 21);
insert into TeamPractices (team_id, practice_id)
values (44, 48);
insert into TeamPractices (team_id, practice_id)
values (38, 13);
insert into TeamPractices (team_id, practice_id)
values (24, 17);
insert into TeamPractices (team_id, practice_id)
values (50, 34);
insert into TeamPractices (team_id, practice_id)
values (32, 40);
insert into TeamPractices (team_id, practice_id)
values (18, 27);
insert into TeamPractices (team_id, practice_id)
values (26, 28);
insert into TeamPractices (team_id, practice_id)
values (52, 15);
insert into TeamPractices (team_id, practice_id)
values (3, 14);
insert into TeamPractices (team_id, practice_id)
values (7, 38);
insert into TeamPractices (team_id, practice_id)
values (31, 30);
insert into TeamPractices (team_id, practice_id)
values (49, 31);
insert into TeamPractices (team_id, practice_id)
values (6, 50);
insert into TeamPractices (team_id, practice_id)
values (23, 39);
insert into TeamPractices (team_id, practice_id)
values (15, 11);
insert into TeamPractices (team_id, practice_id)
values (56, 5);
insert into TeamPractices (team_id, practice_id)
values (2, 4);
insert into TeamPractices (team_id, practice_id)
values (1, 21);
insert into TeamPractices (team_id, practice_id)
values (12, 35);
insert into TeamPractices (team_id, practice_id)
values (46, 18);
insert into TeamPractices (team_id, practice_id)
values (9, 22);
insert into TeamPractices (team_id, practice_id)
values (59, 10);
insert into TeamPractices (team_id, practice_id)
values (42, 19);
insert into TeamPractices (team_id, practice_id)
values (34, 47);
insert into TeamPractices (team_id, practice_id)
values (45, 8);
insert into TeamPractices (team_id, practice_id)
values (20, 29);
insert into TeamPractices (team_id, practice_id)
values (30, 60);
insert into TeamPractices (team_id, practice_id)
values (25, 25);
insert into TeamPractices (team_id, practice_id)
values (13, 59);
insert into TeamPractices (team_id, practice_id)
values (54, 55);
insert into TeamPractices (team_id, practice_id)
values (51, 33);
insert into TeamPractices (team_id, practice_id)
values (57, 7);
insert into TeamPractices (team_id, practice_id)
values (29, 42);
insert into TeamPractices (team_id, practice_id)
values (59, 22);
insert into TeamPractices (team_id, practice_id)
values (35, 20);
insert into TeamPractices (team_id, practice_id)
values (9, 23);
insert into TeamPractices (team_id, practice_id)
values (47, 17);
insert into TeamPractices (team_id, practice_id)
values (37, 27);
insert into TeamPractices (team_id, practice_id)
values (54, 6);
insert into TeamPractices (team_id, practice_id)
values (52, 35);
insert into TeamPractices (team_id, practice_id)
values (60, 14);
insert into TeamPractices (team_id, practice_id)
values (2, 59);
insert into TeamPractices (team_id, practice_id)
values (17, 43);
insert into TeamPractices (team_id, practice_id)
values (25, 18);
insert into TeamPractices (team_id, practice_id)
values (26, 56);
insert into TeamPractices (team_id, practice_id)
values (51, 21);
insert into TeamPractices (team_id, practice_id)
values (43, 53);
insert into TeamPractices (team_id, practice_id)
values (46, 54);
insert into TeamPractices (team_id, practice_id)
values (23, 40);
insert into TeamPractices (team_id, practice_id)
values (8, 37);
insert into TeamPractices (team_id, practice_id)
values (28, 49);
insert into TeamPractices (team_id, practice_id)
values (20, 11);
insert into TeamPractices (team_id, practice_id)
values (58, 51);

insert into PlayerTeams (player_id, team_id)
values (54, 3);
insert into PlayerTeams (player_id, team_id)
values (39, 57);
insert into PlayerTeams (player_id, team_id)
values (57, 51);
insert into PlayerTeams (player_id, team_id)
values (20, 2);
insert into PlayerTeams (player_id, team_id)
values (1, 13);
insert into PlayerTeams (player_id, team_id)
values (58, 31);
insert into PlayerTeams (player_id, team_id)
values (7, 43);
insert into PlayerTeams (player_id, team_id)
values (49, 18);
insert into PlayerTeams (player_id, team_id)
values (28, 41);
insert into PlayerTeams (player_id, team_id)
values (53, 14);
insert into PlayerTeams (player_id, team_id)
values (38, 52);
insert into PlayerTeams (player_id, team_id)
values (41, 30);
insert into PlayerTeams (player_id, team_id)
values (60, 11);
insert into PlayerTeams (player_id, team_id)
values (44, 21);
insert into PlayerTeams (player_id, team_id)
values (25, 17);
insert into PlayerTeams (player_id, team_id)
values (9, 1);
insert into PlayerTeams (player_id, team_id)
values (12, 16);
insert into PlayerTeams (player_id, team_id)
values (31, 26);
insert into PlayerTeams (player_id, team_id)
values (24, 27);
insert into PlayerTeams (player_id, team_id)
values (33, 4);
insert into PlayerTeams (player_id, team_id)
values (18, 19);
insert into PlayerTeams (player_id, team_id)
values (43, 29);
insert into PlayerTeams (player_id, team_id)
values (10, 15);
insert into PlayerTeams (player_id, team_id)
values (5, 48);
insert into PlayerTeams (player_id, team_id)
values (55, 40);
insert into PlayerTeams (player_id, team_id)
values (26, 33);
insert into PlayerTeams (player_id, team_id)
values (47, 32);
insert into PlayerTeams (player_id, team_id)
values (42, 25);
insert into PlayerTeams (player_id, team_id)
values (22, 39);
insert into PlayerTeams (player_id, team_id)
values (16, 54);
insert into PlayerTeams (player_id, team_id)
values (23, 24);
insert into PlayerTeams (player_id, team_id)
values (6, 7);
insert into PlayerTeams (player_id, team_id)
values (17, 8);
insert into PlayerTeams (player_id, team_id)
values (50, 38);
insert into PlayerTeams (player_id, team_id)
values (8, 45);
insert into PlayerTeams (player_id, team_id)
values (35, 50);
insert into PlayerTeams (player_id, team_id)
values (14, 59);
insert into PlayerTeams (player_id, team_id)
values (4, 36);
insert into PlayerTeams (player_id, team_id)
values (3, 47);
insert into PlayerTeams (player_id, team_id)
values (45, 28);
insert into PlayerTeams (player_id, team_id)
values (48, 44);
insert into PlayerTeams (player_id, team_id)
values (15, 46);
insert into PlayerTeams (player_id, team_id)
values (46, 20);
insert into PlayerTeams (player_id, team_id)
values (36, 37);
insert into PlayerTeams (player_id, team_id)
values (51, 12);
insert into PlayerTeams (player_id, team_id)
values (56, 22);
insert into PlayerTeams (player_id, team_id)
values (30, 6);
insert into PlayerTeams (player_id, team_id)
values (34, 60);
insert into PlayerTeams (player_id, team_id)
values (40, 5);
insert into PlayerTeams (player_id, team_id)
values (13, 49);
insert into PlayerTeams (player_id, team_id)
values (2, 23);
insert into PlayerTeams (player_id, team_id)
values (27, 53);
insert into PlayerTeams (player_id, team_id)
values (11, 55);
insert into PlayerTeams (player_id, team_id)
values (37, 56);
insert into PlayerTeams (player_id, team_id)
values (19, 58);
insert into PlayerTeams (player_id, team_id)
values (59, 35);
insert into PlayerTeams (player_id, team_id)
values (52, 42);
insert into PlayerTeams (player_id, team_id)
values (29, 9);
insert into PlayerTeams (player_id, team_id)
values (21, 34);
insert into PlayerTeams (player_id, team_id)
values (32, 10);
insert into PlayerTeams (player_id, team_id)
values (24, 13);
insert into PlayerTeams (player_id, team_id)
values (53, 55);
insert into PlayerTeams (player_id, team_id)
values (57, 52);
insert into PlayerTeams (player_id, team_id)
values (51, 26);
insert into PlayerTeams (player_id, team_id)
values (46, 36);
insert into PlayerTeams (player_id, team_id)
values (10, 33);
insert into PlayerTeams (player_id, team_id)
values (5, 50);
insert into PlayerTeams (player_id, team_id)
values (35, 5);
insert into PlayerTeams (player_id, team_id)
values (38, 46);
insert into PlayerTeams (player_id, team_id)
values (50, 59);
insert into PlayerTeams (player_id, team_id)
values (27, 38);
insert into PlayerTeams (player_id, team_id)
values (9, 54);
insert into PlayerTeams (player_id, team_id)
values (7, 22);
insert into PlayerTeams (player_id, team_id)
values (25, 11);
insert into PlayerTeams (player_id, team_id)
values (31, 47);
insert into PlayerTeams (player_id, team_id)
values (60, 15);
insert into PlayerTeams (player_id, team_id)
values (2, 9);
insert into PlayerTeams (player_id, team_id)
values (42, 48);
insert into PlayerTeams (player_id, team_id)
values (49, 49);
insert into PlayerTeams (player_id, team_id)
values (8, 21);
insert into PlayerTeams (player_id, team_id)
values (6, 41);
insert into PlayerTeams (player_id, team_id)
values (47, 14);
insert into PlayerTeams (player_id, team_id)
values (34, 19);
insert into PlayerTeams (player_id, team_id)
values (56, 17);
insert into PlayerTeams (player_id, team_id)
values (1, 42);
insert into PlayerTeams (player_id, team_id)
values (20, 32);
insert into PlayerTeams (player_id, team_id)
values (58, 10);
insert into PlayerTeams (player_id, team_id)
values (23, 23);
insert into PlayerTeams (player_id, team_id)
values (12, 58);
insert into PlayerTeams (player_id, team_id)
values (16, 6);
insert into PlayerTeams (player_id, team_id)
values (17, 9);
insert into PlayerTeams (player_id, team_id)
values (48, 1);
insert into PlayerTeams (player_id, team_id)
values (18, 45);
insert into PlayerTeams (player_id, team_id)
values (15, 60);
insert into PlayerTeams (player_id, team_id)
values (55, 28);
insert into PlayerTeams (player_id, team_id)
values (32, 39);
insert into PlayerTeams (player_id, team_id)
values (21, 12);
insert into PlayerTeams (player_id, team_id)
values (19, 57);
insert into PlayerTeams (player_id, team_id)
values (39, 7);
insert into PlayerTeams (player_id, team_id)
values (30, 18);
insert into PlayerTeams (player_id, team_id)
values (29, 31);
insert into PlayerTeams (player_id, team_id)
values (11, 52);
insert into PlayerTeams (player_id, team_id)
values (41, 31);
insert into PlayerTeams (player_id, team_id)
values (13, 4);
insert into PlayerTeams (player_id, team_id)
values (45, 44);
insert into PlayerTeams (player_id, team_id)
values (33, 20);
insert into PlayerTeams (player_id, team_id)
values (59, 43);
insert into PlayerTeams (player_id, team_id)
values (3, 35);
insert into PlayerTeams (player_id, team_id)
values (44, 25);
insert into PlayerTeams (player_id, team_id)
values (26, 40);
insert into PlayerTeams (player_id, team_id)
values (43, 3);
insert into PlayerTeams (player_id, team_id)
values (28, 24);
insert into PlayerTeams (player_id, team_id)
values (36, 38);
insert into PlayerTeams (player_id, team_id)
values (54, 56);
insert into PlayerTeams (player_id, team_id)
values (22, 53);
insert into PlayerTeams (player_id, team_id)
values (37, 2);
insert into PlayerTeams (player_id, team_id)
values (4, 16);
insert into PlayerTeams (player_id, team_id)
values (52, 29);
insert into PlayerTeams (player_id, team_id)
values (14, 27);
insert into PlayerTeams (player_id, team_id)
values (40, 34);
insert into PlayerTeams (player_id, team_id)
values (58, 22);
insert into PlayerTeams (player_id, team_id)
values (56, 3);
insert into PlayerTeams (player_id, team_id)
values (40, 18);
insert into PlayerTeams (player_id, team_id)
values (44, 22);
insert into PlayerTeams (player_id, team_id)
values (9, 19);
insert into PlayerTeams (player_id, team_id)
values (39, 26);
insert into PlayerTeams (player_id, team_id)
values (17, 16);
insert into PlayerTeams (player_id, team_id)
values (43, 9);
insert into PlayerTeams (player_id, team_id)
values (28, 38);
insert into PlayerTeams (player_id, team_id)
values (32, 40);
insert into PlayerTeams (player_id, team_id)
values (35, 54);
insert into PlayerTeams (player_id, team_id)
values (47, 28);
insert into PlayerTeams (player_id, team_id)
values (48, 2);
insert into PlayerTeams (player_id, team_id)
values (29, 49);
insert into PlayerTeams (player_id, team_id)
values (53, 1);
insert into PlayerTeams (player_id, team_id)
values (24, 48);
insert into PlayerTeams (player_id, team_id)
values (22, 44);
insert into PlayerTeams (player_id, team_id)
values (27, 25);
insert into PlayerTeams (player_id, team_id)
values (18, 11);
insert into PlayerTeams (player_id, team_id)
values (55, 50);
insert into PlayerTeams (player_id, team_id)
values (26, 32);
insert into PlayerTeams (player_id, team_id)
values (25, 6);
insert into PlayerTeams (player_id, team_id)
values (7, 5);
insert into PlayerTeams (player_id, team_id)
values (57, 37);
insert into PlayerTeams (player_id, team_id)
values (14, 58);
insert into PlayerTeams (player_id, team_id)
values (37, 55);
insert into PlayerTeams (player_id, team_id)
values (11, 33);
insert into PlayerTeams (player_id, team_id)
values (54, 42);
insert into PlayerTeams (player_id, team_id)
values (21, 53);
insert into PlayerTeams (player_id, team_id)
values (1, 24);
insert into PlayerTeams (player_id, team_id)
values (31, 51);
insert into PlayerTeams (player_id, team_id)
values (5, 13);
insert into PlayerTeams (player_id, team_id)
values (3, 17);
insert into PlayerTeams (player_id, team_id)
values (8, 8);
insert into PlayerTeams (player_id, team_id)
values (23, 43);
insert into PlayerTeams (player_id, team_id)
values (10, 41);
insert into PlayerTeams (player_id, team_id)
values (60, 35);
insert into PlayerTeams (player_id, team_id)
values (41, 10);
insert into PlayerTeams (player_id, team_id)
values (30, 27);
insert into PlayerTeams (player_id, team_id)
values (13, 47);
insert into PlayerTeams (player_id, team_id)
values (45, 14);
insert into PlayerTeams (player_id, team_id)
values (2, 52);
insert into PlayerTeams (player_id, team_id)
values (49, 4);
insert into PlayerTeams (player_id, team_id)
values (34, 57);
insert into PlayerTeams (player_id, team_id)
values (42, 15);
insert into PlayerTeams (player_id, team_id)
values (33, 23);
insert into PlayerTeams (player_id, team_id)
values (20, 39);
insert into PlayerTeams (player_id, team_id)
values (16, 31);
insert into PlayerTeams (player_id, team_id)
values (59, 60);
insert into PlayerTeams (player_id, team_id)
values (19, 29);
insert into PlayerTeams (player_id, team_id)
values (46, 59);
insert into PlayerTeams (player_id, team_id)
values (12, 56);
insert into PlayerTeams (player_id, team_id)
values (50, 30);
insert into PlayerTeams (player_id, team_id)
values (36, 36);
insert into PlayerTeams (player_id, team_id)
values (4, 12);
insert into PlayerTeams (player_id, team_id)
values (51, 45);
insert into PlayerTeams (player_id, team_id)
values (6, 46);
insert into PlayerTeams (player_id, team_id)
values (38, 7);
insert into PlayerTeams (player_id, team_id)
values (15, 20);
insert into PlayerTeams (player_id, team_id)
values (52, 34);
insert into PlayerTeams (player_id, team_id)
values (36, 5);
insert into PlayerTeams (player_id, team_id)
values (23, 50);
insert into PlayerTeams (player_id, team_id)
values (24, 32);
insert into PlayerTeams (player_id, team_id)
values (13, 54);
insert into PlayerTeams (player_id, team_id)
values (17, 25);
insert into PlayerTeams (player_id, team_id)
values (4, 15);
insert into PlayerTeams (player_id, team_id)
values (29, 26);
insert into PlayerTeams (player_id, team_id)
values (47, 58);
insert into PlayerTeams (player_id, team_id)
values (58, 43);
insert into PlayerTeams (player_id, team_id)
values (44, 23);
insert into PlayerTeams (player_id, team_id)
values (7, 45);
insert into PlayerTeams (player_id, team_id)
values (52, 28);
insert into PlayerTeams (player_id, team_id)
values (9, 17);
insert into PlayerTeams (player_id, team_id)
values (10, 49);
insert into PlayerTeams (player_id, team_id)
values (21, 54);
insert into PlayerTeams (player_id, team_id)
values (25, 8);
insert into PlayerTeams (player_id, team_id)
values (6, 30);
insert into PlayerTeams (player_id, team_id)
values (42, 22);
insert into PlayerTeams (player_id, team_id)
values (20, 33);
insert into PlayerTeams (player_id, team_id)
values (54, 4);

insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-06-08', 21, 42);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-10', 58, 58);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-13', 3, 44);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-18', 50, 27);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-16', 43, 9);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-07', 13, 51);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-12', 52, 28);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-05', 10, 8);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-05', 57, 11);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-06-13', 38, 50);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-13', 14, 40);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-12-13', 40, 2);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-25', 28, 5);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-05', 60, 60);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-04-03', 31, 1);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-04-06', 56, 14);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-17', 2, 54);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-27', 4, 4);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-16', 55, 49);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-22', 1, 53);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-17', 59, 29);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-30', 41, 46);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-16', 54, 16);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-22', 44, 39);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-12-15', 11, 48);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-24', 48, 15);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-26', 23, 26);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-12-07', 17, 57);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-04-09', 35, 47);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-20', 12, 59);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-25', 36, 10);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-03', 49, 20);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-04-12', 29, 33);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-06', 34, 45);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-23', 9, 22);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-15', 37, 13);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-06-18', 45, 41);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-26', 53, 35);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-06-15', 15, 17);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-29', 39, 24);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-12', 46, 32);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-12', 24, 56);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-11', 8, 18);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-16', 33, 19);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-06-10', 42, 37);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-23', 22, 12);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-29', 6, 7);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-18', 5, 38);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-22', 27, 36);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-12-13', 7, 55);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-03', 16, 3);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-19', 26, 21);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-17', 19, 30);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-09', 18, 31);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-01', 20, 25);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-21', 25, 43);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-09', 32, 6);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-08', 51, 23);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-05', 30, 34);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-06-09', 47, 52);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-11', 13, 52);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-12-20', 48, 10);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-28', 26, 14);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-23', 27, 35);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-12-06', 4, 52);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-14', 36, 28);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-30', 32, 7);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-27', 49, 27);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-06', 55, 31);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-05', 42, 38);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-10', 8, 11);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-23', 47, 21);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-24', 54, 12);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-04', 2, 20);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-14', 39, 23);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-04-23', 30, 26);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-28', 15, 9);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-11', 9, 59);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-09', 33, 6);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-04', 50, 45);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-02', 43, 8);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-12', 35, 42);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-20', 37, 25);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-09', 44, 56);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-22', 34, 55);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-09', 31, 17);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-09', 41, 54);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-08', 7, 57);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-17', 17, 40);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-04-24', 24, 34);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-12', 10, 5);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-21', 46, 1);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-10', 53, 46);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-19', 19, 49);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-25', 28, 58);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-11', 1, 13);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-23', 59, 32);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-27', 51, 24);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-05', 16, 50);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-26', 58, 44);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-27', 56, 3);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-28', 38, 53);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-16', 45, 22);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-16', 20, 18);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-20', 57, 19);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-05', 25, 15);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-28', 5, 4);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-28', 52, 48);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-06-15', 40, 16);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-06-05', 6, 30);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-22', 12, 39);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-22', 18, 38);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-20', 3, 33);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-28', 23, 29);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-25', 21, 43);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-30', 29, 2);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-04-16', 22, 60);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-24', 14, 41);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-19', 60, 36);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-12-22', 11, 47);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-01', 18, 32);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-07', 37, 55);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-24', 16, 5);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-05', 1, 6);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-26', 41, 7);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-26', 9, 60);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-24', 4, 44);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-06-03', 49, 56);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-07', 11, 32);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-28', 54, 51);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-18', 44, 24);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-12', 39, 57);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-13', 7, 42);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-17', 58, 2);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-24', 15, 19);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-23', 30, 13);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-27', 27, 12);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-02', 42, 49);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-21', 17, 10);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-11', 13, 28);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-23', 23, 23);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-17', 45, 20);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-23', 31, 22);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-14', 21, 35);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-12', 8, 30);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-22', 34, 29);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-14', 53, 53);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-21', 35, 46);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-12-11', 26, 18);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-04', 28, 25);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-27', 14, 58);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-30', 60, 48);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-30', 19, 27);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-16', 46, 37);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-08', 52, 59);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-12-22', 38, 45);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-01', 20, 4);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-21', 22, 17);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-06-10', 59, 26);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-30', 33, 36);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-04', 56, 15);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-25', 5, 43);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-27', 25, 14);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-17', 48, 50);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-20', 47, 38);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-25', 50, 54);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-20', 12, 16);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-04', 40, 47);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-25', 29, 21);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-18', 3, 3);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-04-09', 32, 8);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-31', 51, 40);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-18', 6, 34);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-23', 24, 1);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-10', 2, 41);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-12', 10, 11);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-04-25', 55, 9);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-21', 43, 33);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-30', 57, 39);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-07', 36, 52);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-12-09', 3, 39);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-01', 35, 26);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-27', 2, 9);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-17', 34, 8);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-28', 7, 44);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-14', 42, 55);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-22', 57, 6);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-09', 22, 38);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-10', 32, 37);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-21', 37, 18);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-07-03', 58, 53);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-10-05', 48, 21);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-05-24', 4, 34);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-03-29', 55, 41);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-09-07', 60, 20);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-02', 25, 50);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-02-21', 9, 5);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2024-01-25', 26, 32);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-08-08', 11, 52);
insert into FriendList (dateAdded, fan_id, friend_id)
values ('2023-11-28', 50, 47);

insert into LeagueFans (league_id, fan_id)
values (57, 54);
insert into LeagueFans (league_id, fan_id)
values (26, 35);
insert into LeagueFans (league_id, fan_id)
values (3, 11);
insert into LeagueFans (league_id, fan_id)
values (21, 37);
insert into LeagueFans (league_id, fan_id)
values (13, 23);
insert into LeagueFans (league_id, fan_id)
values (7, 52);
insert into LeagueFans (league_id, fan_id)
values (28, 48);
insert into LeagueFans (league_id, fan_id)
values (59, 32);
insert into LeagueFans (league_id, fan_id)
values (6, 34);
insert into LeagueFans (league_id, fan_id)
values (58, 7);
insert into LeagueFans (league_id, fan_id)
values (54, 38);
insert into LeagueFans (league_id, fan_id)
values (12, 25);
insert into LeagueFans (league_id, fan_id)
values (1, 22);
insert into LeagueFans (league_id, fan_id)
values (15, 53);
insert into LeagueFans (league_id, fan_id)
values (32, 33);
insert into LeagueFans (league_id, fan_id)
values (49, 2);
insert into LeagueFans (league_id, fan_id)
values (11, 60);
insert into LeagueFans (league_id, fan_id)
values (55, 27);
insert into LeagueFans (league_id, fan_id)
values (22, 16);
insert into LeagueFans (league_id, fan_id)
values (44, 59);
insert into LeagueFans (league_id, fan_id)
values (43, 49);
insert into LeagueFans (league_id, fan_id)
values (10, 51);
insert into LeagueFans (league_id, fan_id)
values (20, 43);
insert into LeagueFans (league_id, fan_id)
values (27, 58);
insert into LeagueFans (league_id, fan_id)
values (45, 19);
insert into LeagueFans (league_id, fan_id)
values (37, 1);
insert into LeagueFans (league_id, fan_id)
values (25, 18);
insert into LeagueFans (league_id, fan_id)
values (40, 28);
insert into LeagueFans (league_id, fan_id)
values (16, 56);
insert into LeagueFans (league_id, fan_id)
values (14, 24);
insert into LeagueFans (league_id, fan_id)
values (51, 21);
insert into LeagueFans (league_id, fan_id)
values (5, 29);
insert into LeagueFans (league_id, fan_id)
values (41, 44);
insert into LeagueFans (league_id, fan_id)
values (48, 41);
insert into LeagueFans (league_id, fan_id)
values (35, 4);
insert into LeagueFans (league_id, fan_id)
values (50, 47);
insert into LeagueFans (league_id, fan_id)
values (24, 55);
insert into LeagueFans (league_id, fan_id)
values (31, 3);
insert into LeagueFans (league_id, fan_id)
values (36, 13);
insert into LeagueFans (league_id, fan_id)
values (9, 20);
insert into LeagueFans (league_id, fan_id)
values (17, 14);
insert into LeagueFans (league_id, fan_id)
values (60, 10);
insert into LeagueFans (league_id, fan_id)
values (19, 31);
insert into LeagueFans (league_id, fan_id)
values (23, 39);
insert into LeagueFans (league_id, fan_id)
values (39, 46);
insert into LeagueFans (league_id, fan_id)
values (4, 36);
insert into LeagueFans (league_id, fan_id)
values (56, 5);
insert into LeagueFans (league_id, fan_id)
values (38, 50);
insert into LeagueFans (league_id, fan_id)
values (8, 12);
insert into LeagueFans (league_id, fan_id)
values (29, 57);
insert into LeagueFans (league_id, fan_id)
values (33, 8);
insert into LeagueFans (league_id, fan_id)
values (52, 45);
insert into LeagueFans (league_id, fan_id)
values (30, 9);
insert into LeagueFans (league_id, fan_id)
values (2, 26);
insert into LeagueFans (league_id, fan_id)
values (47, 15);
insert into LeagueFans (league_id, fan_id)
values (34, 42);
insert into LeagueFans (league_id, fan_id)
values (53, 30);
insert into LeagueFans (league_id, fan_id)
values (42, 17);
insert into LeagueFans (league_id, fan_id)
values (46, 6);
insert into LeagueFans (league_id, fan_id)
values (18, 40);
insert into LeagueFans (league_id, fan_id)
values (50, 41);
insert into LeagueFans (league_id, fan_id)
values (48, 40);
insert into LeagueFans (league_id, fan_id)
values (7, 10);
insert into LeagueFans (league_id, fan_id)
values (11, 7);
insert into LeagueFans (league_id, fan_id)
values (39, 22);
insert into LeagueFans (league_id, fan_id)
values (58, 54);
insert into LeagueFans (league_id, fan_id)
values (10, 14);
insert into LeagueFans (league_id, fan_id)
values (52, 23);
insert into LeagueFans (league_id, fan_id)
values (45, 50);
insert into LeagueFans (league_id, fan_id)
values (42, 28);
insert into LeagueFans (league_id, fan_id)
values (17, 25);
insert into LeagueFans (league_id, fan_id)
values (22, 59);
insert into LeagueFans (league_id, fan_id)
values (15, 37);
insert into LeagueFans (league_id, fan_id)
values (57, 6);
insert into LeagueFans (league_id, fan_id)
values (6, 45);
insert into LeagueFans (league_id, fan_id)
values (31, 39);
insert into LeagueFans (league_id, fan_id)
values (4, 31);
insert into LeagueFans (league_id, fan_id)
values (26, 3);
insert into LeagueFans (league_id, fan_id)
values (23, 58);
insert into LeagueFans (league_id, fan_id)
values (38, 44);
insert into LeagueFans (league_id, fan_id)
values (49, 48);
insert into LeagueFans (league_id, fan_id)
values (41, 16);
insert into LeagueFans (league_id, fan_id)
values (2, 57);
insert into LeagueFans (league_id, fan_id)
values (19, 33);
insert into LeagueFans (league_id, fan_id)
values (56, 32);
insert into LeagueFans (league_id, fan_id)
values (51, 24);
insert into LeagueFans (league_id, fan_id)
values (8, 13);
insert into LeagueFans (league_id, fan_id)
values (47, 46);
insert into LeagueFans (league_id, fan_id)
values (13, 4);
insert into LeagueFans (league_id, fan_id)
values (3, 12);
insert into LeagueFans (league_id, fan_id)
values (28, 26);
insert into LeagueFans (league_id, fan_id)
values (30, 53);
insert into LeagueFans (league_id, fan_id)
values (14, 51);
insert into LeagueFans (league_id, fan_id)
values (20, 56);
insert into LeagueFans (league_id, fan_id)
values (55, 28);
insert into LeagueFans (league_id, fan_id)
values (27, 38);
insert into LeagueFans (league_id, fan_id)
values (25, 15);
insert into LeagueFans (league_id, fan_id)
values (46, 20);
insert into LeagueFans (league_id, fan_id)
values (21, 43);
insert into LeagueFans (league_id, fan_id)
values (36, 5);
insert into LeagueFans (league_id, fan_id)
values (53, 47);
insert into LeagueFans (league_id, fan_id)
values (44, 8);
insert into LeagueFans (league_id, fan_id)
values (12, 29);
insert into LeagueFans (league_id, fan_id)
values (29, 19);
insert into LeagueFans (league_id, fan_id)
values (33, 52);
insert into LeagueFans (league_id, fan_id)
values (32, 1);
insert into LeagueFans (league_id, fan_id)
values (43, 60);
insert into LeagueFans (league_id, fan_id)
values (9, 42);
insert into LeagueFans (league_id, fan_id)
values (37, 18);
insert into LeagueFans (league_id, fan_id)
values (60, 36);
insert into LeagueFans (league_id, fan_id)
values (16, 34);
insert into LeagueFans (league_id, fan_id)
values (24, 21);
insert into LeagueFans (league_id, fan_id)
values (59, 13);
insert into LeagueFans (league_id, fan_id)
values (1, 30);
insert into LeagueFans (league_id, fan_id)
values (54, 2);
insert into LeagueFans (league_id, fan_id)
values (35, 9);
insert into LeagueFans (league_id, fan_id)
values (18, 17);
insert into LeagueFans (league_id, fan_id)
values (40, 55);
insert into LeagueFans (league_id, fan_id)
values (34, 35);
insert into LeagueFans (league_id, fan_id)
values (5, 49);
insert into LeagueFans (league_id, fan_id)
values (15, 29);
insert into LeagueFans (league_id, fan_id)
values (58, 60);
insert into LeagueFans (league_id, fan_id)
values (43, 37);
insert into LeagueFans (league_id, fan_id)
values (10, 9);
insert into LeagueFans (league_id, fan_id)
values (20, 51);
insert into LeagueFans (league_id, fan_id)
values (11, 17);
insert into LeagueFans (league_id, fan_id)
values (44, 43);
insert into LeagueFans (league_id, fan_id)
values (60, 5);
insert into LeagueFans (league_id, fan_id)
values (48, 55);
insert into LeagueFans (league_id, fan_id)
values (21, 52);
insert into LeagueFans (league_id, fan_id)
values (37, 7);
insert into LeagueFans (league_id, fan_id)
values (2, 8);
insert into LeagueFans (league_id, fan_id)
values (45, 18);
insert into LeagueFans (league_id, fan_id)
values (38, 53);
insert into LeagueFans (league_id, fan_id)
values (49, 41);
insert into LeagueFans (league_id, fan_id)
values (6, 48);
insert into LeagueFans (league_id, fan_id)
values (53, 12);
insert into LeagueFans (league_id, fan_id)
values (47, 1);
insert into LeagueFans (league_id, fan_id)
values (8, 32);
insert into LeagueFans (league_id, fan_id)
values (36, 14);
insert into LeagueFans (league_id, fan_id)
values (50, 59);
insert into LeagueFans (league_id, fan_id)
values (55, 57);
insert into LeagueFans (league_id, fan_id)
values (22, 22);
insert into LeagueFans (league_id, fan_id)
values (28, 24);
insert into LeagueFans (league_id, fan_id)
values (31, 42);
insert into LeagueFans (league_id, fan_id)
values (52, 3);
insert into LeagueFans (league_id, fan_id)
values (16, 20);
insert into LeagueFans (league_id, fan_id)
values (39, 13);
insert into LeagueFans (league_id, fan_id)
values (27, 4);
insert into LeagueFans (league_id, fan_id)
values (12, 6);
insert into LeagueFans (league_id, fan_id)
values (9, 15);
insert into LeagueFans (league_id, fan_id)
values (32, 47);
insert into LeagueFans (league_id, fan_id)
values (56, 58);
insert into LeagueFans (league_id, fan_id)
values (34, 23);
insert into LeagueFans (league_id, fan_id)
values (35, 31);
insert into LeagueFans (league_id, fan_id)
values (17, 38);
insert into LeagueFans (league_id, fan_id)
values (29, 30);
insert into LeagueFans (league_id, fan_id)
values (59, 27);
insert into LeagueFans (league_id, fan_id)
values (41, 26);
insert into LeagueFans (league_id, fan_id)
values (46, 33);
insert into LeagueFans (league_id, fan_id)
values (23, 44);
insert into LeagueFans (league_id, fan_id)
values (13, 46);
insert into LeagueFans (league_id, fan_id)
values (25, 19);
insert into LeagueFans (league_id, fan_id)
values (57, 50);
insert into LeagueFans (league_id, fan_id)
values (19, 45);
insert into LeagueFans (league_id, fan_id)
values (7, 39);
insert into LeagueFans (league_id, fan_id)
values (40, 49);
insert into LeagueFans (league_id, fan_id)
values (33, 35);
insert into LeagueFans (league_id, fan_id)
values (14, 56);
insert into LeagueFans (league_id, fan_id)
values (4, 2);
insert into LeagueFans (league_id, fan_id)
values (24, 25);
insert into LeagueFans (league_id, fan_id)
values (18, 16);
insert into LeagueFans (league_id, fan_id)
values (30, 54);
insert into LeagueFans (league_id, fan_id)
values (26, 11);
insert into LeagueFans (league_id, fan_id)
values (1, 40);
insert into LeagueFans (league_id, fan_id)
values (42, 21);
insert into LeagueFans (league_id, fan_id)
values (3, 36);
insert into LeagueFans (league_id, fan_id)
values (54, 10);
insert into LeagueFans (league_id, fan_id)
values (51, 34);
insert into LeagueFans (league_id, fan_id)
values (5, 28);
insert into LeagueFans (league_id, fan_id)
values (4, 23);
insert into LeagueFans (league_id, fan_id)
values (54, 47);
insert into LeagueFans (league_id, fan_id)
values (24, 6);
insert into LeagueFans (league_id, fan_id)
values (33, 60);
insert into LeagueFans (league_id, fan_id)
values (60, 26);
insert into LeagueFans (league_id, fan_id)
values (42, 54);
insert into LeagueFans (league_id, fan_id)
values (47, 9);
insert into LeagueFans (league_id, fan_id)
values (53, 4);
insert into LeagueFans (league_id, fan_id)
values (59, 43);
insert into LeagueFans (league_id, fan_id)
values (40, 52);
insert into LeagueFans (league_id, fan_id)
values (32, 24);
insert into LeagueFans (league_id, fan_id)
values (9, 55);
insert into LeagueFans (league_id, fan_id)
values (35, 14);
insert into LeagueFans (league_id, fan_id)
values (34, 10);
insert into LeagueFans (league_id, fan_id)
values (37, 31);
insert into LeagueFans (league_id, fan_id)
values (21, 22);
insert into LeagueFans (league_id, fan_id)
values (41, 39);
insert into LeagueFans (league_id, fan_id)
values (26, 16);
insert into LeagueFans (league_id, fan_id)
values (17, 3);
insert into LeagueFans (league_id, fan_id)
values (43, 46);


