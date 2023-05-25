<script lang="ts">
	import { onMount } from 'svelte';
	import type { User } from '../../types/User';

	let otherUser: User;
	let user: User;
	user = { id: '3a9096b3-aea7-4546-a75b-b676dc4a174e' } as User;

	onMount(() => setNextMatch());

	const setNextMatch = () => {
		fetch(`http://localhost:4000/api/links/${user.id}/next`)
			.then((res) => res.json())
			.then((res) => {
				if (res && res.data != 'no matches') otherUser = res.data;
				console.log(res);
			})
			.catch((e) => console.error(e));
	};

	const declineMatch = () => {
		fetch(`http://localhost:4000/api/decline_match/${user.id}/${otherUser.id}`, {
			method: 'PATCH'
		})
			.then((res) => res.json())
			.then((res) => console.log(res))
			.catch((e) => console.error(e));
	};

	const acceptMatch = () => {
		fetch(`http://localhost:4000/api/accept_match/${user.id}/${otherUser.id}`, { method: 'PATCH' })
			.then((res) => res.json())
			.then((res) => console.log(res))
			.catch((e) => console.error(e));
	};
</script>

{#if otherUser}
	<div class="m-2">
		<div class="avatar mb-3 justify-center">
			<div class="w-5/6 rounded-full ring ring-primary md:w-2/5">
				<img src="images/jack_and_buster.jpeg" alt="profile pictue" />
			</div>
		</div>
		<div class="flex flex-col items-center">
			<div class="mb-2 flex w-3/4 justify-center">
				<span class="mr-2 text-3xl font-bold">{otherUser.name}</span>
				<span class="flex items-end text-2xl">{otherUser.age}</span>
			</div>
			<div>{otherUser.location}</div>
			<div>{otherUser.major}</div>
		</div>
		<div class="flex justify-center">
			<div class="flex w-full justify-between md:w-1/2">
				<button on:click={declineMatch} class="btn m-2 w-28 md:w-32">skip</button>
				<button on:click={acceptMatch} class="btn m-2 w-28 md:w-32">match</button>
			</div>
		</div>
	</div>
{/if}
