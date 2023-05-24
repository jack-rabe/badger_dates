<script lang="ts">
	let form: HTMLFormElement;
	function handleSubmit(_e: Event) {
		const formData = new FormData(form);
		fetch('http://localhost:4000/api/users', {
			method: 'POST',
			body: formData
		})
			.then((response) => {
				console.log(response);
			})
			.catch((error) => {
				console.error(error);
			});
	}
</script>

<form bind:this={form} on:submit|preventDefault={handleSubmit} class="form-control m-4 gap-4">
	<label class="grid grid-cols-4">
		Name:
		<input name="name" type="text" required class="input input-bordered col-span-3" />
	</label>

	<label class="grid grid-cols-4">
		Age:
		<input name="age" type="number" required class="input input-bordered col-span-3" />
	</label>

	<label class="grid grid-cols-4">
		Location:
		<input name="location" type="string" required class="input input-bordered col-span-3" />
	</label>

	<label class="grid grid-cols-4">
		Major:
		<input name="major" type="string" required class="input input-bordered col-span-3" />
	</label>

	<button class="btn" type="submit">Submit</button>
</form>
