async function loadRegistrations() {

    const emailInput = document.getElementById("email");
    const container = document.getElementById("registrations-container");

    let email = emailInput.value.trim();

    // Remove accidental Markdown mailto formatting
    const mailtoMatch = email.match(
        /^\[([^\]]+)\]\(mailto:[^)]+\)$/i
    );

    if (mailtoMatch) {
        email = mailtoMatch[1].trim();
    }

    // Clear previous results
    container.innerHTML = "";

    // Validate email
    if (!email) {
        container.innerHTML = `
            <div class="registration-message error">
                Please enter your email address.
            </div>
        `;
        return;
    }

    // Basic email validation
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!emailPattern.test(email)) {
        container.innerHTML = `
            <div class="registration-message error">
                Please enter a valid email address.
            </div>
        `;
        return;
    }

    // Loading message
    container.innerHTML = `
        <div class="registration-loading">
            Loading your registrations...
        </div>
    `;

    try {

        const response = await fetch(
            `${API_BASE_URL}/registrations/${encodeURIComponent(email)}`
        );

        const data = await response.json();

        console.log("Registrations response:", data);

        if (!response.ok) {

            throw new Error(
                data.message ||
                data.error ||
                "Unable to load registrations."
            );
        }

        /*
         * Your API may return the registrations directly
         * or inside a data property.
         */
        const registrations =
            Array.isArray(data)
                ? data
                : data.data || data.registrations || [];

        if (registrations.length === 0) {

            container.innerHTML = `
                <div class="registration-empty">
                    <h3>No registrations found</h3>
                    <p>
                        We couldn't find any event registrations
                        for this email address.
                    </p>
                </div>
            `;

            return;
        }

        renderRegistrations(registrations);

    } catch (error) {

        console.error(
            "Load registrations error:",
            error
        );

        container.innerHTML = `
            <div class="registration-message error">
                ${error.message || "Unable to load registrations."}
            </div>
        `;
    }
}


/* =========================================================
   DISPLAY REGISTRATIONS
   ========================================================= */

function renderRegistrations(registrations) {

    const container =
        document.getElementById("registrations-container");

    container.innerHTML = `
        <div class="registrations-heading">
            <h2>
                Your Registrations
                <span class="registration-count">
                    ${registrations.length}
                </span>
            </h2>

            <p>
                Showing your registration history.
            </p>
        </div>

        <div class="registrations-list">

            ${registrations.map(registration => {

                const eventId =
                    registration.event_id || "N/A";

                const ticketId =
                    registration.ticket_id || "N/A";

                const registrationId =
                    registration.registration_id || "N/A";

                const fullName =
                    registration.full_name || "Registered User";

                const status =
                    registration.status || "CONFIRMED";

                const registeredOn =
                    registration.registered_at ||
                    registration.created_at ||
                    "N/A";

                return `
                    <article class="registration-result-card">

                        <div class="registration-result-info">

                            <span class="registration-event-label">
                                EVENT
                            </span>

                            <h3>
                                ${eventId}
                            </h3>

                            <p>
                                Registered for this event
                                successfully.
                            </p>

                        </div>


                        <div class="registration-result-details">

                            <div>
                                <span>Registrant</span>
                                <strong>
                                    ${fullName}
                                </strong>
                            </div>

                            <div>
                                <span>Ticket ID</span>
                                <strong>
                                    ${ticketId}
                                </strong>
                            </div>

                            <div>
                                <span>Registration ID</span>
                                <strong>
                                    ${registrationId}
                                </strong>
                            </div>

                            <div>
                                <span>Status</span>
                                <strong class="status-confirmed">
                                    ${status}
                                </strong>
                            </div>

                        </div>


                        <div class="registration-result-actions">

                            <button
                                type="button"
                                class="cancel-registration-btn"
                                onclick="cancelRegistration('${registrationId}')"
                            >
                                Cancel Registration
                            </button>

                        </div>

                    </article>
                `;

            }).join("")}

        </div>
    `;
}


/* =========================================================
   CANCEL REGISTRATION
   ========================================================= */

async function cancelRegistration(registrationId) {

    const confirmed =
        confirm(
            "Are you sure you want to cancel this registration?"
        );

    if (!confirmed) {
        return;
    }

    try {

        const response = await fetch(
            `${API_BASE_URL}/registration/${encodeURIComponent(registrationId)}`,
            {
                method: "DELETE"
            }
        );

        const data = await response.json();

        console.log(
            "Cancel registration response:",
            data
        );

        if (!response.ok) {

            throw new Error(
                data.message ||
                data.error ||
                "Unable to cancel registration."
            );
        }

        alert(
            data.message ||
            "Registration cancelled successfully."
        );

        // Reload registrations
        loadRegistrations();

    } catch (error) {

        console.error(
            "Cancel registration error:",
            error
        );

        alert(
            error.message ||
            "Unable to cancel registration."
        );
    }
}