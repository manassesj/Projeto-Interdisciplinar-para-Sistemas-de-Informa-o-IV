class Station {
    constructor(name, temp_air, humidity_air) {
        this.name = name;
        this.temp_air = temp_air;
        this.humidity_air = humidity_air;
    }
}

module.exports = {
    Station: Station,
};
