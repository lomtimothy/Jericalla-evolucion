import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext
import os

# Diccionario de opcodes según la convención:
opcode_map = {
    "ADD": "00",
    "SUB": "01",
    "TERN": "10",
    "SW": "11"
}

def reg_to_bin(reg):
    """Convierte un registro del tipo '$4' a una cadena binaria de 5 bits."""
    try:
        # Remueve el signo '$' y convierte a entero
        num = int(reg.replace("$", ""))
        return format(num, '05b')
    except:
        return None

def convert_line(line):
    """Convierte una línea de ASM a una instrucción binaria de 17 bits."""
    tokens = line.strip().split()
    if not tokens:
        return ""
    mnemonic = tokens[0].upper()
    if mnemonic not in opcode_map:
        return f"Error: Instrucción desconocida '{mnemonic}'"
    
    opcode = opcode_map[mnemonic]
    
    # Para ADD, SUB y TERN esperamos 4 tokens: mnemonic, $dest, $src1, $src2
    if mnemonic in ["ADD", "SUB", "TERN"]:
        if len(tokens) != 4:
            return f"Error: Número incorrecto de operandos en '{line.strip()}'"
        dest = reg_to_bin(tokens[1])
        src1 = reg_to_bin(tokens[2])
        src2 = reg_to_bin(tokens[3])
        if None in (dest, src1, src2):
            return f"Error: Formato de registro incorrecto en '{line.strip()}'"
        # Formato: 2 bits (opcode) + 5 bits dest + 5 bits src1 + 5 bits src2
        return opcode + dest + src1 + src2

    # Para SW esperamos 3 tokens: mnemonic, $memoria, $registro
    elif mnemonic == "SW":
        if len(tokens) != 3:
            return f"Error: Número incorrecto de operandos en '{line.strip()}'"
        # En el ejemplo, se usa un campo fijo "11111" para el segundo campo
        fixed_field = "11111"
        mem_addr = reg_to_bin(tokens[1])
        reg_field = reg_to_bin(tokens[2])
        if None in (mem_addr, reg_field):
            return f"Error: Formato de registro incorrecto en '{line.strip()}'"
        # Formato: 2 bits (opcode) + 5 bits fijos + 5 bits memoria + 5 bits registro
        return opcode + fixed_field + mem_addr + reg_field

    else:
        return f"Error: Instrucción no soportada '{mnemonic}'"

def load_asm():
    filepath = filedialog.askopenfilename(title="Selecciona el archivo ASM", filetypes=[("ASM Files", "*.ASM"), ("All Files", "*.*")])
    if filepath:
        try:
            with open(filepath, "r") as f:
                content = f.read()
            asm_text.delete(1.0, tk.END)
            asm_text.insert(tk.END, content)
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo cargar el archivo: {e}")

def convert_asm_to_bin():
    asm_content = asm_text.get(1.0, tk.END)
    lines = asm_content.strip().splitlines()
    bin_lines = []
    for line in lines:
        # Saltear líneas vacías o comentarios (si se agregan con ; o //)
        if line.strip() == "" or line.strip().startswith(("//", ";")):
            continue
        bin_line = convert_line(line)
        bin_lines.append(bin_line)
    bin_result = "\n".join(bin_lines)
    bin_text.delete(1.0, tk.END)
    bin_text.insert(tk.END, bin_result)
    messagebox.showinfo("Conversión", "Conversión a binario completada.")

def save_bin():
    bin_result = bin_text.get(1.0, tk.END)
    if not bin_result.strip():
        messagebox.showwarning("Aviso", "No hay contenido binario para guardar.")
        return
    filepath = filedialog.asksaveasfilename(title="Guardar archivo binario", defaultextension=".txt", filetypes=[("Text Files", "*.txt")])
    if filepath:
        try:
            with open(filepath, "w") as f:
                f.write(bin_result)
            messagebox.showinfo("Guardado", "Archivo guardado exitosamente.")
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo guardar el archivo: {e}")

# Creación de la ventana principal de la GUI
root = tk.Tk()
root.title("Conversor ASM a Binario")

# Botones y áreas de texto
frame_buttons = tk.Frame(root)
frame_buttons.pack(pady=5)

btn_load = tk.Button(frame_buttons, text="Cargar ASM", command=load_asm)
btn_load.grid(row=0, column=0, padx=5)

btn_convert = tk.Button(frame_buttons, text="Convertir a Binario", command=convert_asm_to_bin)
btn_convert.grid(row=0, column=1, padx=5)

btn_save = tk.Button(frame_buttons, text="Guardar Binario", command=save_bin)
btn_save.grid(row=0, column=2, padx=5)

# Área de texto para mostrar el contenido ASM
lbl_asm = tk.Label(root, text="Contenido ASM:")
lbl_asm.pack()
asm_text = scrolledtext.ScrolledText(root, width=70, height=10)
asm_text.pack(padx=10, pady=5)

# Área de texto para mostrar el contenido binario resultante
lbl_bin = tk.Label(root, text="Contenido Binario:")
lbl_bin.pack()
bin_text = scrolledtext.ScrolledText(root, width=70, height=10)
bin_text.pack(padx=10, pady=5)

root.mainloop()

