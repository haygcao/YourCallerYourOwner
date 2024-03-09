class Contact:
    def __init__(self, name, number):
        self.name = name
        self.number = number

class Call:
    def __init__(self, contact, duration):
        self.contact = contact
        self.duration = duration

class CallerApp:
    def __init__(self):
        self.contacts = {}
        self.call_history = []

    def add_contact(self, name, number):
        contact = Contact(name, number)
        self.contacts[name] = contact

    def make_call(self, contact_name, duration):
        if contact_name in self.contacts:
            contact = self.contacts[contact_name]
            call = Call(contact, duration)
            self.call_history.append(call)
            print(f"Calling {contact_name} ({contact.number})... Duration: {duration} minutes")
        else:
            print(f"Contact '{contact_name}' not found.")

    def view_call_history(self):
        print("Call History:")
        for i, call in enumerate(self.call_history, start=1):
            print(f"{i}. {call.contact.name} ({call.contact.number}) - Duration: {call.duration} minutes")

if __name__ == "__main__":
    app = CallerApp()

    while True:
        print("\nOptions:")
        print("1. Add Contact")
        print("2. Make Call")
        print("3. View Call History")
        print("4. Quit")

        choice = input("Enter your choice: ")

        if choice == "1":
            name = input("Enter contact name: ")
            number = input("Enter contact number: ")
            app.add_contact(name, number)
        elif choice == "2":
            contact_name = input("Enter contact name to call: ")
            duration = input("Enter call duration (in minutes): ")
            app.make_call(contact_name, duration)
        elif choice == "3":
            app.view_call_history()
        elif choice == "4":
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")
