// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import Elm from "./penny";
import channel from "./socket";

channel.push('mode:get');

const elmNode = document.querySelector('#elm');
if( elmNode )
{
    const app = Elm.Penny.embed( elmNode, "" );

    channel.on( "mode", mode => {
	console.log( mode );
	app.ports.mode.send( mode );
    });

    app.ports.publish.subscribe( ({topic,body}) => {
	console.log( topic, body );
	channel.push( topic, body );
    });
}

