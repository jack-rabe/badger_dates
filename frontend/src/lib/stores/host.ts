import { writable } from 'svelte/store';
import { dev } from '$app/environment';

let _hostname = 'TODO';
if (dev) {
	_hostname = 'localhost:4000';
}

export const hostname = writable(_hostname);
