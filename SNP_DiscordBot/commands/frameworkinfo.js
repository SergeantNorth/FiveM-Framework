const config = require('../config.json')
const { MessageEmbed } = require('discord.js');

module.exports.run = async(client, message, args) => {
    message.delete()
    connection.query(`SELECT * FROM characters`, (err, reslove) => {
        if (err) {
            let e1 = new MessageEmbed()
                .setDescription(`I had error checking the database. If this is an ongoing issue please contact NAT2K15 for help`)
                .setColor(config.embed.color)
            message.channel.send(e1)
        }

        if (!reslove[0]) {
            let e2 = new MessageEmbed()
                .setDescription(`There are no characters within the database`)
                .setColor(config.embed.color)
            message.channel.send(e2)
        } else {
            let num = 0;
            reslove.forEach(result => {
                num++;
            })
            let e3 = new MessageEmbed()
                .setDescription(`There are ${num.toLocaleString()} characters in the database!`)
                .setColor(config.embed.color)
            message.channel.send(e3)
        }
    })
}

module.exports.help = {
    name: "frameworkinfo",
    description: "shows the framework info",
    usage: "",
    category: "Mod",
    aliases: []
};