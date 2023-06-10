<script lang="ts">
	import { onMount } from 'svelte';
	import type { Message } from '../../types/Message';
	import { Channel, Socket } from 'phoenix';
	import { userId } from '$lib/stores/user';

	let channel: Channel;
	let messageToSend: string;
	let messages: Message[] = [];

	const linkId = '74407b56-952a-4215-aec4-dafa4057b8f6';

	onMount(() => {
		const url = 'ws://localhost:4000/conversation';
		const socket = new Socket(url, {});
		socket.connect();
		channel = socket.channel('conversation:lobby', {});
		channel
			.join()
			.receive('ok', (_res) => {
				console.log('Channel joined successfully');
			})
			.receive('error', (response) => {
				console.error('Unable to join channel', response);
			});

		channel.on('message_sent', (payload) => {
			messages.push(payload);
			messages = messages;
		});

		fetch(`http://localhost:4000/api/messages?user_link=${linkId}`)
			.then((res) => res.json())
			.then((res) => {
				messages = res.data;
			})
			.catch((e) => console.error(e));
	});

	const sendMessage = () => {
		if (!channel) {
			console.error('no open channel');
			return;
		}

		channel.push('create_message', { content: messageToSend, user_id: $userId, link_id: linkId });
		messageToSend = '';
	};
</script>

{#each messages as msg}
	{#if msg.user === $userId}
		<div class="chat chat-start m-2">
			<div class="chat-bubble chat-bubble-primary text-xl md:text-2xl">{msg.content}</div>
		</div>
	{:else}
		<div class="chat chat-end m-2">
			<div class="chat-bubble chat-bubble-secondary text-xl md:text-2xl">{msg.content}</div>
		</div>
	{/if}
{/each}

<div class="flex">
	<input
		type="text"
		on:keydown={(event) => {
			if (event.key !== 'Enter') {
				return;
			}
			sendMessage();
		}}
		bind:value={messageToSend}
		class="input-primary input m-2"
	/>
	<button class="btn m-2" on:click={sendMessage}>send</button>
</div>
