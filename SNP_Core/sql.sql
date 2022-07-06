-- THIS FILE GETS AUTO IMPORTED BY THE FRAMEWORK -- 
CREATE TABLE characters (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  discord varchar(50) DEFAULT NULL,
  steamid varchar(50) DEFAULT NULL,
  first_name varchar(50) DEFAULT NULL,
  last_name varchar(50) DEFAULT NULL,
  twotter_name varchar(50) DEFAULT NULl,
  dob varchar(50) DEFAULT NULL,
  gender varchar(50) DEFAULT NULL,
  dept varchar(50) DEFAULT NULL
);

CREATE TABLE char_playing (
  discord varchar(50) DEFAULT NULL,
  steamid varchar(50) DEFAULT NULL,
  char_name varchar(50) DEFAULT NULL,
  twotter_name varchar(50) DEFAULT NULl,
  dob varchar(50) DEFAULT NULL,
  gender varchar(50) DEFAULT NULL,
  dept varchar(50) DEFAULT NULL
);

CREATE TABLE characters_settings(
  discord varchar(50) DEFAULT NULL,
  steamid varchar(50) DEFAULT NULL,
  dark_mode varchar(50) DEFAULT "1",
  cloud_spawning varchar(50) DEFAULT "1",
  image_slideshow varchar(50) DEFAULT "0",
  character_gardient_color varchar(50) DEFAULT "#DDADF3|#582185",
  refresh_gardient_color varchar(50) DEFAULT "#3E3BDF|#6529C5",
  settings_gardient_color varchar(50) DEFAULT "#1792DA|#49C06D",
  disconnect_gardient_color varchar(50) DEFAULT "#FF0000|#EB7F27"
);