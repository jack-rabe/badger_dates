<script lang="ts">
	import { onMount, afterUpdate } from 'svelte';
	import type { Message } from '$lib/types/Message';
	import type { User } from '$lib/types/User';
	import { Channel, Socket } from 'phoenix';
	import { userId } from '$lib/stores/user';
	import { page } from '$app/stores';
	import { hostname } from '$lib/stores/host';

	let channel: Channel;
	let messageToSend: string;
	let messages: Message[] = [];
	let messagesElement: HTMLElement;

	const linkId = $page.params.link_id;
	const otherUserId = $page.params.other_user_id;
	let otherUser: User;

	// scroll to the bottom so that the newest messages are seen
	afterUpdate(() => {
		if (messages) scrollToBottom(messagesElement);
	});
	const scrollToBottom = async (node: HTMLElement) => {
		node.scroll({ top: node.scrollHeight, behavior: 'smooth' });
	};

	onMount(() => {
		const url = `ws://${$hostname}/conversation`;
		const socket = new Socket(url, {});
		socket.connect();
		channel = socket.channel(`conversation:${linkId}`, {});
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

		fetch(`http://${$hostname}/api/messages?user_link=${linkId}`)
			.then((res) => res.json())
			.then((res) => {
				messages = res.data;
			})
			.catch((e) => console.error(e));

		fetch(`http://${$hostname}/api/users/${otherUserId}`)
			.then((res) => res.json())
			.then((res) => {
				otherUser = res.data;
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

{#if otherUser}
	<div
		class="m-1 flex items-center justify-center rounded-lg border border-primary bg-secondary p-2 text-xl font-bold"
	>
		{otherUser.name}
		<div class="avatar ml-2">
			<div class="w-12 rounded-full">
				<img src={otherUser.image_url} alt="profile pic" />
			</div>
		</div>
	</div>
{/if}
<div bind:this={messagesElement} id="i" class="h-3/4 overflow-scroll">
	{#each messages as msg}
		{#if msg.user === $userId}
			<div class="chat chat-start m-2">
				<div class="chat-bubble chat-bubble-primary text-xl md:text-2xl">
					{msg.content}
				</div>
			</div>
		{:else}
			<div class="chat chat-end m-2">
				<div class="chat-bubble chat-bubble-secondary text-xl md:text-2xl">{msg.content}</div>
			</div>
		{/if}
	{/each}
</div>

<div>
	<input
		type="text"
		on:keydown={(event) => {
			if (event.key !== 'Enter') {
				return;
			}
			sendMessage();
		}}
		bind:value={messageToSend}
		class="input-primary input m-2 w-3/5"
	/>
	<button class="btn m-2" on:click={sendMessage}>send</button>
</div>
