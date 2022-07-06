const config = require('../config.json')
const { MessageEmbed } = require('discord.js');

module.exports.run = async(client, message, args) => {
    message.delete()
    let member = message.mentions.members.first() || message.guild.members.cache.get(args[0]);
    if (!member) {
        let e1 = new MessageEmbed()
            .setDescription(`Please make sure to mention a valid user!`)
            .setColor(config.embed.color)
            .setFooter(config.embed.footer)
        message.channel.send(e1).then(msg => msg.delete({ timeout: 10000 }));
    } else {
        connection.query(`SELECT * FROM characters WHERE discord = '${member.id}'`, (err, reslove) => {
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
                embed.setTitle(`Below are the result found for ${member.user.tag}`)
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

module.exports.help = {
    name: "search",
    description: "shows the framework info",
    usage: "",
    category: "Mod",
    aliases: []
};