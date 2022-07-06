const { Client, Collection, MessageEmbed } = require('discord.js');
const client = new Client();
const fs = require('fs');
const config = require("./config.json");
const root = GetResourcePath(GetCurrentResourceName());

client.config = config;
client.root = root
client.commands = new Collection();

const mysql = require('mysql');
connection = mysql.createPool({
    connectionLimit: 10,
    host: config["database"].host,
    user: config["database"].user,
    password: config["database"].password,
    database: config["database"].name,
});

//command handler

fs.readdir(`${root}/commands/`, (err, files) => {
    if (err || err && config.debug) return console.log(`No files were found within the command foldar! If you are still having issues. Contact SergeantNorth#1650 on discord or by joining his development server ^1https://discord.gg/sergeantnorth^0`);
    let file = files.filter(f => f.split(".").pop() === "js")
    if (file.length <= 0) {
        if (config.debug) return console.log(`No files were found within the command foldar! If you are still having issues. Contact SergeantNorth#1650 on discord or by joining his development server ^1https://discord.gg/sergeantnorth^0`);
    } else {
        file.forEach((files) => {
            let commandfiles = require(`./commands/${files}`);
            client.commands.set(commandfiles.help.name, commandfiles);
            if (config.debug) {
                console.log(`^2[File Loaded] ${files}^0`)
            }
        });

    }
});

client.on('message', async(message) => {
    let prefix = config.prefix;
    if (message.author.bot) return;
    if (message.channel.type === "dm") return;
    let messageArray = message.content.split(" ");
    let cmd = messageArray[0].toLowerCase();
    let args = messageArray.slice(1);
    if (!message.content.startsWith(prefix)) return;
    let commandfile = client.commands.get(cmd.slice(prefix.length));
    if (commandfile) commandfile.run(client, message, args);
});

client.once('ready', () => {
    console.log(`${client.user.tag} is now online!`)
})


if (config.sql_backups == true) {
    const mysqldump = require('mysqldump')
    let num = 0;
    setInterval(() => {
        let newnum = num++;
        mysqldump({
            connection: {
                host: config["database"].host,
                user: config["database"].user,
                password: config["database"].password,
                database: config["database"].name,
            },
            dumpToFile: `./sql/backup${newnum}.sql`,
        });
    }, 21600000); //6 hours
}



client.login(config.token)