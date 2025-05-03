import { getBuyers, addBuyer } from './database.js';
import { sha256 } from 'js-sha256';

async function test() {
    await addBuyer({ username: 'lttin', password: sha256("12345"), email: "lttin605@gmail.com" })
    console.log(await getUsers())
}


test();