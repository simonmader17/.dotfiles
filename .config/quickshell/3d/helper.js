// helper.js
.pragma library

/**
 * Returns either dark or light depending on the luminance of the input color.
 * @param {color} inputColor - The input color.
 * @param {any} dark - The value to return if the input color is light.
 * @param {any} light - The value to return if the input color is dark.
 * @returns {any} Returns the `dark` value for light input colors and `light` for dark ones.
 */
function contrastColor(inputColor, dark, light) {
	// Calculate relative luminance
	// Formula from Wikipedia: 0.2126*R + 0.7152*G + 0.0722*B
	let luma = (0.2126 * inputColor.r) + (0.7152 * inputColor.g) + (0.0722 * inputColor.b);
	return luma > 0.5 ? dark : light;
}

/**
 * Selects an icon from an array based on a percentage value.
 * @param {Array<any>} icons - An array of icons.
 * @param {number} per - A number value representing the percentage (0 to 1).
 * @returns {any} The icon corresponding to the specific percentage bucket.
 */
function chooseIconBasedOnPercentage(icons, per) {
	let index = Math.min(Math.floor(per * icons.length), icons.length - 1);
	return icons[index];
}
