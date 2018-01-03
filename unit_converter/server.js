'use strict';

const http = require('http');
const url = require('url');

function _getConversion(data, name) {
    for (let unit of data.units) {
        if (name === unit.name) {
            return unit.conversion;
        }
    }
    return null;
}

const server = http.createServer((req, res) => {
    // This has to be set inside because it needs to change on each request
    const data = {
        'units': [
            {'name': 'US Dollar',
             'conversion': 1.0,
             'description': 'It is a little-known fact that the production cost of each item in the Dollar Menu is the true driver for the fluctuations in the US Dollar.'
            },
            {'name': 'Brownie Points',
             'conversion': Math.random() * 0.3 + 0.8,
             'description': 'While not a "monetary" currency, Brownie Points are a form of social currency that include doing favors and helping others.'
            },
            {'name': 'Bitcoin',
             'conversion': Math.random() * 0.0001 + 0.00007285714,
             'description': 'A decentralized digital currency that can be created by "mining".'
            },
            {'name': 'Galleon',
             'conversion': Math.random() * 0.005 + 0.017,
             'description': "In the Magical Wizarding World, everyone carries around giant bags of Galleons, which doesn't seem practical but sure is idyllic."
            },
            {'name': 'Gold Bar',
             'conversion': Math.random() * 0.00003 + 0.00078988941,
             'description': 'When exchanging for a bar of gold, it is always important to specify the bar-size. Here, we use the 400-troy-ounce, but there also exists the kilobar, and various gram-sized bars.'
            },
            {'name': 'Zimbabwean Dollar',
             'conversion': Math.random() * 27000.0 + 2000000000.0,
             'description': 'The Zimbabwean Dollar is a textbook example of hyperinflation.'
            }
        ]
    };

    if ((req.url === '/currency' || req.url === '/currency/') && req.method === 'GET') {
        res.end(JSON.stringify(data));
    } else if (req.url.startsWith('/currency/convert') && req.method === 'GET') {
        const parsedUrl = url.parse(req.url, true);
        const units = parsedUrl.query;
        let message = [];
        if (units.amount == null) {
            message.push('Missing `amount` query parameter.');
        }
        if (units.from == null) {
            message.push('Missing `from` query parameter.');
        }
        if (units.to == null) {
            message.push('Missing `to` query parameter.');
        }
        const from = _getConversion(data, units.from);
        const to = _getConversion(data, units.to);
        if (from == null) {
            message.push('Invalid `from` query parameter.');
        }
        if (to == null) {
            message.push('Invalid `to` query parameter.');
        }
        if (message.length !== 0) {
            res.statusCode = '400';
            res.end(JSON.stringify({'status': 'error', 'message': message}));
        }
        res.end(JSON.stringify({'status': 'ok', 'conversion': units.amount * to/from}));
    } else {
        res.end('Welcome to the API for the Unit Converter!');
    }
});
server.on('clientError', (err, socket) => {
    socket.end('HTTP/1.1 400 Bad Request\r\n\r\n');
});
server.listen(8000);
