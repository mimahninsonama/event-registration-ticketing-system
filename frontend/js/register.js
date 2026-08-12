async function registerEvent() {

    const eventId = document.getElementById("event_id").value.trim();
    const fullName = document.getElementById("full_name").value.trim();
    const email = document.getElementById("email").value.trim();

    const message = document.getElementById("registration-message");
    const button = document.querySelector(".registration-submit");

    // Clear previous message
    message.className = "registration-message";
    message.textContent = "";

    // Validate required fields
    if (!eventId || !fullName || !email) {
        message.textContent =
            "Please complete all fields before registering.";

        message.classList.add("error");
        return;
    }

    // Validate email
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!emailPattern.test(email)) {
        message.textContent =
            "Please enter a valid email address.";

        message.classList.add("error");
        return;
    }

    // Disable button while request is processing
    button.disabled = true;

    button.innerHTML = `
        <span>Processing...</span>
    `;

    try {

        const response = await fetch(
            `${API_BASE_URL}/register`,
            {
                method: "POST",

                headers: {
                    "Content-Type": "application/json"
                },

                body: JSON.stringify({
                    event_id: eventId,
                    full_name: fullName,
                    email: email
                })
            }
        );

        const data = await response.json();

        console.log("Registration response:", data);

        if (!response.ok) {
            throw new Error(
                data.message ||
                data.error ||
                "Registration failed."
            );
        }

        // Success
        message.textContent =
            data.message ||
            "Registration successful! Your ticket has been created.";

        message.classList.add("success");

        button.disabled = false;

        button.innerHTML = `
            <span>Registration Complete</span>
            <span class="button-arrow">✓</span>
        `;

    } catch (error) {

        console.error("Registration error:", error);

        message.textContent =
            error.message ||
            "Unable to complete registration. Please try again.";

        message.classList.add("error");

        button.disabled = false;

        button.innerHTML = `
            <span>Complete Registration</span>
            <span class="button-arrow">→</span>
        `;
    }
}