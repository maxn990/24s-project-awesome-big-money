CREATE DATABASE IF NOT EXISTS LocalLeagueLegends;

USE LocalLeagueLegends;

CREATE TABLE IF NOT EXISTS Managers
(
    manager_id INTEGER,
    firstName  VARCHAR(40)  NOT NULL,
    lastName   VARCHAR(40)  NOT NULL,
    email      VARCHAR(100) NOT NULL,
    phone      VARCHAR(15)  NOT NULL,
    address    VARCHAR(100) NOT NULL,
    PRIMARY KEY (manager_id)
);

INSERT INTO Managers (manager_id, firstName, lastName, email, phone, address)
VALUES (1, 'Brett', 'Abrams', 'babrams@icloud.com', '123456789', '1 Main St, Springfield, CO, 12345');
INSERT INTO Managers (manager_id, firstName, lastName, email, phone, address)
VALUES (2, 'Geddy', 'Lee', 'geddy@rush.com', '1112222112', '22 Bytor Street, Toronto, ON, Canada, 2112');

CREATE TABLE IF NOT EXISTS Leagues
(
    league_id  INTEGER,
    sportType VARCHAR(40) NOT NULL,
    name       VARCHAR(40) NOT NULL,
    manager_id INTEGER     NOT NULL,
    PRIMARY KEY (league_id),
    CONSTRAINT fk_01
        FOREIGN KEY (manager_id) REFERENCES Managers (manager_id)
        ON UPDATE cascade ON DELETE restrict
);

INSERT INTO Leagues (league_id, sportType, name, manager_id)
VALUES (1, 'Basketball', 'SD Youth Basketball League', 1),
       (2, 'Pickleball', 'New Port Beach 60+ Pickleball Club', 2);

CREATE TABLE IF NOT EXISTS Teams
(
    team_id   INTEGER,
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

INSERT INTO Teams (season, team_id, teamName, league_id, wins, losses)
VALUES ('Q1-2024', 1, 'Team Awesome Big Money', 1, 7, 3),
       ('Q3-2023', 2, 'Blue team', 2, 7, 3);

CREATE TABLE IF NOT EXISTS Players
(
    player_id INTEGER,
    lastName  VARCHAR(40)  NOT NULL,
    firstName VARCHAR(40)  NOT NULL,
    email     VARCHAR(40)  NOT NULL,
    address   VARCHAR(100) NOT NULL,
    phone     VARCHAR(15)  NOT NULL,
    PRIMARY KEY (player_id)
);

INSERT INTO Players (player_id, lastName, firstName, email, address, phone)
VALUES (1, 'Peart', 'Neil', 'peart@gmail.com', '12345 Rush Rd, Santa Monica, CA, 34421', '1233211122'),
       (2, 'Lifeson', 'Alex', 'a.lifeson@lerxt.com', '11 Cygnus Ln, Reno, NV, 12343', '45678909');

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

INSERT INTO PlayerProfile (fouls, assists, points, sport, player_id)
VALUES (1, 3, 100, 'Basketball', 1),
       (4, 4, 30, 'Pickleball', 2);


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

INSERT INTO PlayerTeams (player_id, team_id)
VALUES (1, 1),
       (2, 2);

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

INSERT INTO TeamProfile (sport, team_id, points, assists, fouls)
VALUES ('Basketball', 1, 100, 3, 1),
       ('Pickleball', 2, 30, 4, 4);

CREATE TABLE IF NOT EXISTS Fans
(
    fan_id    INTEGER,
    firstName VARCHAR(40)  NOT NULL,
    lastName  VARCHAR(40)  NOT NULL,
    address   VARCHAR(100) NOT NULL,
    phone     VARCHAR(15)  NOT NULL,
    email     VARCHAR(40)  NOT NULL,
    PRIMARY KEY (fan_id)

);

INSERT INTO Fans (fan_id, firstName, lastName, address, phone, email)
VALUES (1, 'Donna', 'Halper', '4 Random St, Quincy MA, 01224', '1112223333', 'donna@donnahalper.com'),
       (2, 'Ray', 'Daniels', '17823 Halfmoon Bay Dr, Los Angeles, CA, 15313', '9988776665', 'ray@mercuryrecords.com');

CREATE TABLE IF NOT EXISTS LeagueFans
(
    leauge_id integer NOT NULL,
    fan_id integer NOT NULL,
    PRIMARY KEY (leauge_id, fan_id),
    CONSTRAINT fk_19
        FOREIGN KEY (leauge_id) REFERENCES Leagues(league_id)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_20
        FOREIGN KEY (fan_id) REFERENCES Fans(fan_id)
        ON UPDATE cascade ON DELETE restrict
);

INSERT INTO LeagueFans (leauge_id, fan_id)
VALUES (1, 1),
       (2, 2);

CREATE TABLE IF NOT EXISTS FriendList
(
    fan_id    INTEGER,
    friend_id INTEGER,
    dateAdded DATE NOT NULL,
    PRIMARY KEY (fan_id, friend_id),
    CONSTRAINT fk_08
        FOREIGN KEY (fan_id) REFERENCES Fans (fan_id)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_09
        FOREIGN KEY (friend_id) REFERENCES Fans (fan_id)
        ON UPDATE cascade ON DELETE restrict
);


INSERT INTO FriendList (fan_id, friend_id, dateAdded)
VALUES (1, 2, CURRENT_DATE);

CREATE TABLE IF NOT EXISTS Coaches
(
    coach_id  INTEGER,
    firstName VARCHAR(40) NOT NULL,
    lastName  VARCHAR(40) NOT NULL,
    email     VARCHAR(40) NOT NULL,
    phone     VARCHAR(15) NOT NULL,
    team_id   INTEGER     NOT NULL,
    PRIMARY KEY (coach_id),
    CONSTRAINT fk_10
        FOREIGN KEY (team_id) REFERENCES Teams (team_id)
        ON UPDATE cascade ON DELETE restrict
);

INSERT INTO Coaches (coach_id, firstName, lastName, email, phone, team_id)
VALUES (1, 'Ted', 'Lasso', 'lasso@afcrichmond.com', '12343141311', 1),
       (2, 'Ana', 'Vidovic', 'vidovic@siccasguitars.com', '1234124351', 2);

CREATE TABLE IF NOT EXISTS Games
(
    game_id   INTEGER,
    date      DATE        NOT NULL,
    winner_id INTEGER,
    time      TIME        NOT NULL,
    referee   VARCHAR(80) NOT NULL,
    state     VARCHAR(2)  NOT NULL,
    city      VARCHAR(40) NOT NULL,
    park      VARCHAR(40) NOT NULL,
    PRIMARY KEY (game_id)
);

INSERT INTO Games (game_id, date, winner_id, time, referee, state, city, park)
VALUES (1, CURRENT_DATE, 0, CURRENT_TIME, 'Mark Fontenot', 'MA', 'Boston', 'Fenway'),
       (2, CURRENT_DATE, 1, CURRENT_TIME, 'JS Bach', 'UT', 'Salt Lake City', 'Park Park');

CREATE TABLE IF NOT EXISTS GameCoaches
(
    coach_id INTEGER,
    game_id INTEGER,
    PRIMARY KEY (coach_id, game_id),
    CONSTRAINT fk_21
        FOREIGN KEY (coach_id) REFERENCES Coaches(coach_id)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_22
        FOREIGN KEY (game_id) REFERENCES Games(game_id)
        ON UPDATE cascade ON DELETE restrict
);

INSERT INTO GameCoaches (coach_id, game_id)
VALUES (1, 1),
       (2, 2);

CREATE TABLE IF NOT EXISTS PlayerStats
(
    player_id INTEGER,
    game_id   INTEGER,
    points    INTEGER DEFAULT 0,
    assists   INTEGER DEFAULT 0,
    fouls     INTEGER DEFAULT 0,
    PRIMARY KEY (player_id, game_id),
    CONSTRAINT fk_11
        FOREIGN KEY (player_id) REFERENCES Players (player_id)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_12
        FOREIGN KEY (game_id) REFERENCES Games (game_id)
        ON UPDATE cascade ON DELETE restrict
);

INSERT INTO PlayerStats (player_id, game_id)
VALUES (1, 1);
INSERT INTO PlayerStats (player_id, game_id, points, assists, fouls)
VALUES (2, 1, 15, 30, 2);

CREATE TABLE IF NOT EXISTS TeamStats
(
    team_id INTEGER,
    game_id INTEGER,
    fouls   INTEGER DEFAULT 0,
    assists INTEGER DEFAULT 0,
    points  INTEGER DEFAULT 0,
    PRIMARY KEY (team_id, game_id),
    CONSTRAINT fk_13
        FOREIGN KEY (team_id) REFERENCES Teams (team_id)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_14
        FOREIGN KEY (game_id) REFERENCES Games (game_id)
        ON UPDATE cascade ON DELETE restrict
);

INSERT INTO TeamStats (team_id, game_id, fouls, assists, points)
VALUES (1, 1, 1, 2, 3),
       (2, 2, 5, 8, 12);

CREATE TABLE IF NOT EXISTS GameAttendance
(
    game_id   INTEGER,
    player_id INTEGER,
    PRIMARY KEY (game_id, player_id),
    CONSTRAINT fk_15
        FOREIGN KEY (game_id) REFERENCES Games (game_id)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_16
        FOREIGN KEY (player_id) REFERENCES Players (player_id)
        ON UPDATE cascade ON DELETE restrict
);

INSERT INTO GameAttendance (game_id, player_id)
VALUES (1, 1),
       (2, 2);

CREATE TABLE IF NOT EXISTS Practices
(
    practice_id INTEGER,
    time        TIME        NOT NULL,
    date        DATE        NOT NULL,
    state       VARCHAR(2)  NOT NULL,
    city        VARCHAR(40) NOT NULL,
    park        VARCHAR(40) NOT NULL,
    PRIMARY KEY (practice_id)
);


INSERT INTO Practices (practice_id, time, date, state, city, park)
VALUES (1, CURRENT_TIME, CURRENT_DATE, 'AZ', 'Yuma', 'Cactus Park'),
       (2, CURRENT_TIME, CURRENT_DATE, 'KS', 'Topeka', 'Topeka State Park');

CREATE TABLE IF NOT EXISTS PracticeAttendance
(
    practice_id INTEGER,
    player_id   INTEGER,
    PRIMARY KEY (practice_id, player_id),
    CONSTRAINT fk_17
        FOREIGN KEY (practice_id) REFERENCES Practices (practice_id)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_18
        FOREIGN KEY (player_id) REFERENCES Players (player_id)
        ON UPDATE cascade ON DELETE restrict
);

INSERT INTO PracticeAttendance (practice_id, player_id)
VALUES (1, 1),
       (2, 2);

CREATE TABLE IF NOT EXISTS TeamGames
(
    team_id INTEGER,
    player_id INTEGER,
    PRIMARY KEY (team_id, player_id),
    CONSTRAINT fk_23
        FOREIGN KEY (team_id) REFERENCES Teams (team_id)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_24
        FOREIGN KEY (player_id) REFERENCES Players (player_id)
        ON UPDATE cascade ON DELETE restrict
);

INSERT INTO TeamGames (team_id, player_id)
VALUES (1,1),
       (2,2);

CREATE TABLE IF NOT EXISTS TeamPractices
(
    practice_id INTEGER,
    team_id INTEGER,
    PRIMARY KEY (practice_id, team_id),
    CONSTRAINT fk_25
        FOREIGN KEY (practice_id) REFERENCES Practices (practice_id)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_26
        FOREIGN KEY (team_id) REFERENCES Teams (team_id)
        ON UPDATE cascade ON DELETE restrict
);

INSERT INTO TeamPractices (practice_id, team_id)
VALUES (1,1),
       (2,2)
    