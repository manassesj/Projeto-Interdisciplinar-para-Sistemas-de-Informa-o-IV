const express = require("express");
const bodyParse = require("body-parser");
const cors = require("cors");
const axios = require("axios");
const AWS = require("aws-sdk");

const dateTime = require("./utils/dateTime");

const kinesis = new AWS.Kinesis();
const app = express();

app.use(cors());
app.use(bodyParse.json());

const url = "https://apitempo.inmet.gov.br/estacao/dados/";

app.get("/", async (request, response) => {
    const { day, hours_minutes } = dateTime();

    try {
        const apiResponse = await axios.get(`${url}${day}/${hours_minutes}`);

        const data = apiResponse.data;

        var dado, record;
        var station_list = [];

        data.map((station) => {
            if (station.UF == "PE") {
                dado = {
                    name: station.DC_NOME,
                    temp_air: station.TEM_INS,
                    humidity_air: station.UMD_INS,
                };

                record = {
                    Data: JSON.stringify(dado),
                    PartitionKey: station.DC_NOME,
                };

                station_list.push(record);
            }
        });

        teste = [station_list[0], station_list[1], station_list[3]];

        var recordsParams = {
            Records: teste,
            StreamName: "project-4-data-stream",
        };

        
        kinesis.putRecords(recordsParams, function (err, data) {
            if (err) {
                return response.status(400).json({ error: err });
            } else {
                console.log(recordsParams);
                return response.status(200).json({
                    data: data,
                    dataFrame: teste,
                });
            }
        });
    } catch (error) {
        return response.status(400).json({ error: error });
    }
});

module.exports = app;
