async function loadRegistrations() {

    const email =
        document.getElementById("email").value;

    if (!email) {

        alert("Enter your email.");

        return;
    }

    const container =
        document.getElementById(
            "registrations-container"
        );

    container.innerHTML =
        "<p>Loading...</p>";

    try {

        const response =
            await apiRequest(
                `/registrations/${email}`
            );

        if (!response.success) {

            container.innerHTML = `
                <div class="card">

                    <p>${response.message}</p>

                </div>
            `;

            return;
        }

        if (response.data.length === 0) {

            container.innerHTML = `
                <div class="card">

                    <p>No registrations found.</p>

                </div>
            `;

            return;
        }

        container.innerHTML = "";

        response.data.forEach(registration => {

            container.innerHTML += `

                <div class="registration-card">

                    <h3>${registration.event_id}</h3>

                    <p>

                        Ticket:
                        ${registration.ticket_id}

                    </p>

                    <p>

                        Status:
                        ${registration.status}

                    </p>

                    <p>

                        Registered:
                        ${registration.registered_at}

                    </p>

                    <button
                        onclick="cancelRegistration('${registration.registration_id}')">

                        Cancel Registration

                    </button>

                </div>

            `;

        });

    }

    catch (error) {

        console.error(error);

        container.innerHTML = `
            <div class="card">

                Error loading registrations.

            </div>
        `;

    }

}

async function cancelRegistration(id) {

    if (!confirm(
        "Cancel this registration?"
    )) {

        return;

    }

    const response =
        await apiRequest(
            `/registration/${id}`,
            "DELETE"
        );

    alert(response.message);

    loadRegistrations();

}