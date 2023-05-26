<script lang="ts">
	const locationOptions = ['Southeast', 'Lakeshore', 'Off-Campus'];
	let form: HTMLFormElement;
	function handleSubmit(_e: Event) {
		const formData = new FormData(form);

		fetch('http://localhost:4000/api/users', {
			method: 'POST',
			body: formData
		})
			.then((_res) => {
				window.location.href = '/match';
			})
			.catch((e) => {
				console.error(e);
			});
	}
</script>

<form bind:this={form} on:submit|preventDefault={handleSubmit} class="form-control m-4 gap-4">
	<label class="input-group w-1/2">
		<span>Name</span>
		<input name="name" type="text" required class="input-bordered input w-full" />
	</label>
	<label class="input-group w-1/2">
		<span>Age</span>
		<input name="age" type="number" required class="input-bordered input w-full" />
	</label>
	<label class="input-group w-1/2">
		<span>Major</span>
		<input name="major" type="text" required class="input-bordered input w-full" />
	</label>

	<label class="input-group w-1/2">
		<span>Location</span>
		<!-- TODO fix this width -->
		<select name="location" required class="select-bordered select w-full">
			<option selected disabled />
			{#each locationOptions as opt}
				<option>{opt}</option>
			{/each}
		</select>
	</label>

	<div class="form-control">
		<label for="profile-picture" class="label">
			<span class="label-text">Pick a profile picture</span>
		</label>
		<input
			id="profile-picture"
			name="profile-picture"
			type="file"
			required
			accept="image/*"
			class="file-input-bordered file-input max-w-xs"
		/>
	</div>

	<button class="btn" type="submit">Submit</button>
</form>
