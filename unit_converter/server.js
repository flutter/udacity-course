'use strict';

const http = require('http');

const server = http.createServer((req, res) => {
    if (req.url === '/currency') {
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
                 'conversion': Math.random() * 0.00018779342,
                 'description': 'A decentralized digital currency that can be created by "mining".'
                },
                {'name': 'Galleon',
                 'conversion': Math.random() * 0.005 + 0.02,
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
        res.end(JSON.stringify(data));
    } else {
        res.end('Welcome to the API for the Unit Converter!');
    }
});
server.on('clientError', (err, socket) => {
  socket.end('HTTP/1.1 400 Bad Request\r\n\r\n');
});
server.listen(8000);
