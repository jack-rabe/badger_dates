<script lang="ts">
	import { onMount } from 'svelte';
	import type { User } from '../../types/User';
	import { userId } from '$lib/stores/user';

	let matches: User[] = [];

	onMount(() => {
		fetch(`http://localhost:4000/api/links/${$userId}/confirmed_matches`)
			.then((res) => res.json())
			.then((res) => {
				matches = res.data;
			})
			.catch((e) => console.error(e));
	});
</script>

<div class="grid grid-cols-2 md:grid-cols-3">
	{#each matches as match}
		<a href={`/message/${match.link_id}`} class="card m-2 bg-base-100 shadow-xl">
			<figure><img src={match.image_url} alt="profile pic" /></figure>
			<div class="card-body">
				<h2 class="card-title">{match.name}</h2>
				<div class="flex">
					<div class="mx-2">{match.major}</div>
					<div>{match.location}</div>
				</div>
			</div>
		</a>
	{/each}
</div>
