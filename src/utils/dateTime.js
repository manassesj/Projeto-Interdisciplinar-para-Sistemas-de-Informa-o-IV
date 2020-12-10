function dateTime() {
    var data = new Date();

    var dia = data.getDate(); // 1-31
    var mes = data.getMonth(); // 0-11 (zero=janeiro)
    var ano4 = data.getFullYear(); // 4 dígitos
    var hora = data.getHours(); // 0-23

    var list_result = [dia, mes, ano4, hora];

    index = 0;

    while (index < list_result.length) {
        if (list_result[index] < 10) {
            list_result[index] = `0${list_result[index]}`;
        }
        index++;
    }

    day = list_result[2] + "-" + (list_result[1] + 1) + "-" + list_result[0];
    hours_minutes = `${list_result[3]}00`;

    return {
        day: day,
        hours_minutes: hours_minutes,
    };
}

module.exports = dateTime;
