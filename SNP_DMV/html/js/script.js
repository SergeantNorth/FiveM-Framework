let cars = undefined
let server_name = "NAT2K15 Development DMV"
let user = "Name: "
$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.action == "dmv_open") {            
            cars = event.data.vehicles;
            server_name = event.data.name;
            user = event.data.us
            mainpage();
        } else if(event.data.action == "refresh_vehicles") {
            cars = event.data.vehicles;
            server_name = event.data.name;
            user = event.data.us
            refreshpage();
        } else if(event.data.action == "closeui") {
            clearui()
            $.post('http://dmv/close', JSON.stringify({}));
        }
    });

    $('#registerCur').click(function() {
        $.post('https://dmv/registerCur')

    })

    $('#closeui').click(function() {
        clearui()
        $.post('http://dmv/close', JSON.stringify({}));
    })

    $("#makeyourown").click(secondPage)

    $("#goback").click(mainpage)

    $("#createdavehicle").click(function() {   
        $.post("http://dmv/createyourown", JSON.stringify({
            plate: $("#vehicleplate").val(),
            type: $("#vehicletype").val(),
            color: $("#vehiclecolor").val(),
        }))
    })
});


function mainpage() {
    clearui()
    $("#name").html(server_name)
    $('.vehicles').html('')
    $("#first").css('display', "block");
    $("#firstpage").css('display', "block");
    $("#username").html(`Name: ${user}`)
    if (!cars) return;
    $.each(cars, function(index, car) {
        if(index == 0) {
            $('.vehicles').append(`<div id="${cars[index].vecid}"><button style="font-size: 14px;" class="btn btn-primary">${cars[index].type} (${cars[index].color}) Plate: ${cars[index].plate}</button>   <button onclick="DeleteCar(${cars[index].vecid}, '${cars[index].plate}')" style="font-size: 14px;" class="btn btn-danger">Delete Vehicle</button></div>`)
        } else {
            $('.vehicles').append(`<div id="${cars[index].vecid}"><br><button style="font-size: 14px;" class="btn btn-primary">${cars[index].type} (${cars[index].color}) Plate: ${cars[index].plate}</button>   <button onclick="DeleteCar(${cars[index].vecid}, '${cars[index].plate}')" style="font-size: 14px;" class="btn btn-danger">Delete Vehicle</button></br></div>`)

        }
    })
}

function secondPage() {
    clearui()
    $("#first").css('display', "block");
    $("#firstpage").css('display', "none");
    $("#secondpage").css('display', "block");
    $("#name").html(server_name)
    $("#first").css('display', "block");
}


function refreshpage() {
    if (!cars) return;
    clearui()
    $("#name").html(server_name)
    $('.vehicles').html('')
    $("#first").css('display', "block");
    $("#firstpage").css('display', "block");
    $("#username").html(`Name: ${user}`)
    $.each(cars, function(index, car) {
        if(index == 0) {
            $('.vehicles').append(`<div id="${cars[index].vecid}"><button style="font-size: 14px;" class="btn btn-primary">${cars[index].type} (${cars[index].color}) Plate: ${cars[index].plate}</button>   <button onclick="DeleteCar(${cars[index].vecid}, '${cars[index].plate}')" style="font-size: 14px;" class="btn btn-danger">Delete Vehicle</button></div>`)
        } else {
            $('.vehicles').append(`<div id="${cars[index].vecid}"><br><button style="font-size: 14px;" class="btn btn-primary">${cars[index].type} (${cars[index].color}) Plate: ${cars[index].plate}</button>   <button onclick="DeleteCar(${cars[index].vecid}, '${cars[index].plate}')" style="font-size: 14px;" class="btn btn-danger">Delete Vehicle</button></br></div>`)

        }
    })
}

function DeleteCar(id, vehicleplate) {
    let value = document.getElementById(id)
    value.parentNode.removeChild(value)
    $.post('http://dmv/delete', JSON.stringify({ carid: id, plate: vehicleplate }));
}

function clearui() {
    $("#first").css('display', "none");
    $("#secondpage").css('display', "none");

}