const config = require('../config.json')
const { MessageEmbed } = require('discord.js');

module.exports.run = async(client, message, args) => {
    message.delete()
    let steamhex = args[0];
    if (!steamhex) {
        let e1 = new MessageEmbed()
            .setDescription(`Please make sure to input the users steamhex!`)
            .setColor(config.embed.color)
            .setFooter(config.embed.footer)
        message.channel.send(e1).then(msg => msg.delete({ timeout: 10000 }));
    } else {
        steamhex = steamhex.toLowerCase();
        if (!steamhex.startsWith("steam:")) {
            let e2 = new MessageEmbed()
                .setDescription(`The steam hex must start with \`steam:\``)
                .setColor(config.embed.color)
                .setFooter(config.embed.footer)
            message.channel.send(e2).then(msg => msg.delete({ timeout: 10000 }));
        } else {
            connection.query(`SELECT * FROM characters WHERE steamid = '${steamhex}'`, (err, reslove) => {
                if (err) {
                    let e2 = new MessageEmbed()
                        .setDescription(`I had an error checking the database`)
                        .setColor(config.embed.color)
                        .setFooter(config.embed.footer)
                    message.channel.send(e2)
                } else {
                    let embed = new MessageEmbed();
                    embed.setColor(config.embed.color)
                    embed.setFooter(config.embed.footer)
                    embed.setTitle(`Below are the result found for \`${steamhex}\``)
                    embed.setTimestamp()
                    reslove.forEach(chars => {
                        embed.addField(`Name`, `${chars.first_name} ${chars.last_name}`, true)
                        embed.addField(`Gender`, chars.gender, true)
                        embed.addField(`Department`, chars.dept, true)
                    })
                    message.channel.send(embed)
                }
            })
        }
    }
}

module.exports.help = {
    name: "searchex",
    description: "searchs trough a user hex",
    usage: "",
    category: "Mod",
    aliases: []
};