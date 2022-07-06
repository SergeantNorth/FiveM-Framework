$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.action == 'id_open') {
            $("body").fadeIn();
            let name = event.data.name;
            let gender = event.data.gender
            let dob = event.data.dob
            let value = Math.floor(Math.random() * 100) + 125

            $('img').show();
            $('#name').css('color', '#282828');

            if (gender.toLowerCase() == 'male') {
                $('img').attr('src', 'assets/images/male.png');
                $('#sex').text('male');
            } else {
                $('img').attr('src', 'assets/images/female.png');
                $('#sex').text('female');
            }
            $('#name').text(name);
            $('#dob').text(dob);
            $('#height').text(value);
            $('#signature').text(name);
            $('#id-card').css('background', 'url(assets/images/background.png)');


            $('#id-card').show();
        } else if (event.data.action == 'id_close') {
            $("body").fadeOut();
        }
    });
});