'use strict';

const http = require('http');

const server = http.createServer((req, res) => {
    console.log(req.url);
    if (req.url === '/currency') {
        const data = {
            'units': [
                {'name': 'Dollar',
                 'conversion': 1.0,
                 'description': 'The dollar menu was created long before the US dollar.'
                },
                {'name': 'Canadian Dollars',
                 'conversion': (Math.random() * 0.3 + 0.8).toFixed(2),
                 'description': 'The dollar menu was created long before the US dollar.'
                },
                {'name': 'Bitcoin',
                 'conversion': (Math.random() * 0.00018779342).toFixed(2),
                 'description': 'The dollar menu was created long before the US dollar.'
                },
                {'name': 'Indian Rupee',
                 'conversion': (Math.random() * 4.0 + 65.0).toFixed(2),
                 'description': 'The dollar menu was created long before the US dollar.'
                },
                {'name': 'Euro',
                 'conversion': (Math.random() * 0.2 + 0.8).toFixed(2),
                 'description': 'The dollar menu was created long before the US dollar.'
                },
                {'name': 'Mongolian Tugrik',
                 'conversion': (Math.random() * 30.0 + 2461.0).toFixed(2),
                 'description': 'The dollar menu was created long before the US dollar.'
                },
                {'name': 'Galleon',
                 'conversion': (Math.random() * 0.005 + 0.02).toFixed(2),
                 'description': 'The dollar menu was created long before the US dollar.'
                },
                {'name': 'Zimbabwean Dollar',
                 'conversion': (Math.random() * 27000.0 + 2000000000.0).toFixed(2),
                 'description': 'The Zimbabwean Dollar was subjected to hyperinflation.'
                },
                {'name': 'Bar of Gold',
                 'conversion': (Math.random() * 0.00003 + 0.00078988941).toFixed(2),
                 'description': ''
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
