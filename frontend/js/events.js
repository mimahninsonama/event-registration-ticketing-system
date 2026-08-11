async function loadEvents() {
    const container = document.getElementById("events-container");

    container.innerHTML = `
        <div class="loading">
            Loading available events...
        </div>
    `;

    try {
        const response = await apiRequest("/events");

        console.log("Events API response:", response);

        const events = Array.isArray(response)
            ? response
            : response.data || response.events || [];

        if (!events.length) {
            container.innerHTML = `
                <div class="empty-state">
                    No events are currently available.
                </div>
            `;
            return;
        }

        displayEvents(events);

    } catch (error) {
        console.error("Failed to load events:", error);

        container.innerHTML = `
            <div class="empty-state">
                Unable to load events. Please try again later.
            </div>
        `;
    }
}


function displayEvents(events) {
    const container = document.getElementById("events-container");

    container.innerHTML = "";

    events.forEach(event => {

        const card = document.createElement("article");

        card.className = "event-card";

        card.innerHTML = `

            <div class="event-content">

                <h2>
                    ${escapeHtml(event.title || "Unnamed Event")}
                </h2>

                <p class="event-description">
                    ${escapeHtml(
                        event.description ||
                        "Join us for this upcoming event."
                    )}
                </p>

                <div class="event-info">

                    <span>
                        📅 ${escapeHtml(event.date || "Date TBA")}
                    </span>

                    <span>
                        📍 ${escapeHtml(event.location || "Location TBA")}
                    </span>

                </div>

                <span class="event-id">
                    ${escapeHtml(event.event_id)}
                </span>

                <a
                    class="register-button"
                    href="register.html?event_id=${encodeURIComponent(
                        event.event_id
                    )}"
                >
                    Register Now →
                </a>

            </div>
        `;

        container.appendChild(card);
    });
}


function escapeHtml(value) {
    const div = document.createElement("div");

    div.textContent = value ?? "";

    return div.innerHTML;
}


loadEvents();