from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

notes = []
note_id_counter = 0

@app.route('/api/notes', methods=['GET', 'POST'])
def handle_notes():
    global note_id_counter
    if request.method == 'GET':
        return jsonify(notes)
    elif request.method == 'POST':
        note = request.json
        note['id'] = note_id_counter
        notes.append(note)
        note_id_counter += 1
        return jsonify({"message": "Note added successfully"})

@app.route('/api/notes/<int:id>', methods=['DELETE', 'PUT'])
def handle_single_note(id):
    if request.method == 'DELETE':
        for note in notes:
            if note['id'] == id:
                notes.remove(note)
                return jsonify({"message": "Note deleted successfully"})
        return jsonify({"message": "Note not found"}), 404
    elif request.method == 'PUT':
        data = request.json
        for note in notes:
            if note['id'] == id:
                note['content'] = data.get('content')
                return jsonify({"message": "Note updated successfully"})
        return jsonify({"message": "Note not found"}), 404

if __name__ == '__main__':
    app.run(debug=True)
