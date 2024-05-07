//
//  File.swift
//


/*
 
 //
 //  TakePhotoView.swift
 //  Macro
 //
 //  Created by Jose Miguel Torres Chavez Nava on 06/05/24.
 //

 import SwiftUI

 /// Vista sencilla para capturar una fotografía desde el dispositivo físico.
 struct TakePhotoView: View {

     // Controla la visibilidad de la interfaz de la cámara.
     @State private var showCamera = false
     // Almacena la imagen capturada por la cámara.
     @State private var image: UIImage?
     
     var body: some View {
         VStack {
             Button("Open Camera") {
                 // Al pulsar el botón, se activa la cámara
                 self.showCamera = true
             }
         }
         // Vista modal que se muestra cuando showCamera es true.
         .sheet(isPresented: $showCamera) {
             // Mostramos la vista de la cámara.
             CameraView(image: $image, isShown: $showCamera)
         }
         // Si se realizan cambios en la variable de la imagen...
         .onChange(of: image) { oldValue, newValue in
             // Verificamos si hay una nueva imagen válida.
             if let validImage = newValue {
                 // Llamamos a una función para procesar la imagen si es válida.
                 processImage(validImage)
             }
         }
     }
 }


 //
 //  CameraView.swift
 //  Macro
 //
 //  Created by Jose Miguel Torres Chavez Nava on 06/05/24.
 //

 import SwiftUI
 import AVFoundation

 /// Vista que maneja la cámara.
 struct CameraView: UIViewControllerRepresentable {
     // Binding para una imagen que permitirá actualizar la imagen en la vista que muestra esta cámara.
     @Binding var image: UIImage?
     // Binding para controlar la visibilidad de esta vista de cámara desde otra vista.
     @Binding var isShown: Bool

     /// Configuramos un UIImagePickerController (un ViewController) para obtener una imagen desde la cámara.
     func makeUIViewController(context: Context) -> UIImagePickerController {
         // Creamos un controlador de selección de imagen.
         let picker = UIImagePickerController()
         // Establecemos el delegado del picker al coordinador que gestionará los eventos del UIImagePickerController.
         picker.delegate = context.coordinator
         // Especificamos que la fuente de imágenes debe ser la cámara del dispositivo.
         picker.sourceType = .camera
         // Regresamos la imagen obtenida en un picker.
         return picker
     }

     /// Actualizamos el UIViewController con nueva información. En este caso, no necesitamos hacer nada aquí.
     func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

     /// Creamos un coordinador que ayudará a manejar la comunicación entre este representable de UIKit y SwiftUI.
     func makeCoordinator() -> Coordinator {
         // Instanciamos un nuevo Coordinador, pasando una referencia a esta instancia de CameraView.
         Coordinator(self)
     }

     /// Definimos una clase interna Coordinator que hereda de NSObject y cumple con los protocolos necesarios para actuar como delegado de UINavigationController y UIImagePickerController.
     class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
         // Mantenemos una referencia a la vista de cámara para poder actualizarla.
         var parent: CameraView

         /* Inicializamos el coordinador con la vista de cámara. */
         init(_ parent: CameraView) {
             self.parent = parent
         }

         /// Maneja el evento de finalización de selección de imagen.
         func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             // Extraemos la imagen original seleccionada.
             if let image = info[.originalImage] as? UIImage {
                 // Asignamos la imagen al binding de la vista de cámara para que se pueda usar en otras vistas.
                 parent.image = image
             }
             // Cerramos la vista de la cámara estableciendo isShown en falso.
             parent.isShown = false
         }
     }
 }

 
 //
 //  TextRecognition.swift
 //  Macro
 //
 //  Created by Jose Miguel Torres Chavez Nava on 06/05/24.
 //

 import SwiftUI
 import AVFoundation
 import Vision

 /// Realizamos el reconocimiento de texto en imágenes usando el framework Vision de Apple, manejamos errores potenciales y convertimos coordenadas de rectángulos normalizados a coordenadas de imagen. Esta función es crucial para interpretar texto directamente desde imágenes capturadas o seleccionadas.
 func processImage(_ image: UIImage) {
     /* Nos aseguramos de que la imagen tenga una representación CGImage y si no, salimos de la función. */
     guard let cgImage = image.cgImage else { return }

     /* Creamos una solicitud de reconocimiento de texto utilizando Vision. */
     let request = VNRecognizeTextRequest { request, error in
         /* Verificamos que no haya errores y que el resultado pueda ser interpretado como una colección de observaciones de texto. */
         guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
             // Imprimimos un mensaje de error si la petición falla.
             print("Recognition failed: \(error?.localizedDescription ?? "Unknown error")")
             return
         }

         /* Mapeamos las observaciones a un arreglo de tuplas que contienen el texto reconocido y sus rectángulos delimitadores. */
         let recognizedStrings: [(String, CGRect)] = observations.compactMap { observation in
             /* Extraemos el texto más probable de ser correcto y su caja delimitadora. */
             guard let topCandidate = observation.topCandidates(1).first else { return nil }
             let boundingBox = observation.boundingBox
             // Convertimos las coordenadas normalizadas de la caja delimitadora a coordenadas de la imagen.
             let imageRect = VNImageRectForNormalizedRect(boundingBox, Int(cgImage.width), Int(cgImage.height))
             // Retornamos una tupla con el texto y su caja.
             return (topCandidate.string, imageRect)
         }

         /* Iteramos sobre los textos reconocidos y sus cajas para imprimirlos. */
         for (text, rect) in recognizedStrings {
             print("Recognized text: \(text) in box: \(rect)")
         }
     }
     
     // Configuramos y ejecutamos la petición de reconocimiento de texto con Vision.
     let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
     
     do {
         // Intentamos realizar la petición.
         try requestHandler.perform([request])
     } catch {
         // Imprimimos un mensaje si la ejecución falla.
         print("Unable to perform the request: \(error)")
     }
 }

 /// Convierte rectángulos con coordenadas normalizadas a coordenadas de imagen reales.
 func VNImageRectForNormalizedRect(_ normalizedRect: CGRect, _ imageWidth: Int, _ imageHeight: Int) -> CGRect {
     /* Calculamos las coordenadas (x, y), así como el ancho y el alto en números reales */
     let x = normalizedRect.minX * CGFloat(imageWidth)
     let y = normalizedRect.minY * CGFloat(imageHeight)
     let width = normalizedRect.width * CGFloat(imageWidth)
     let height = normalizedRect.height * CGFloat(imageHeight)
     // Regresamos el rectángulo con dimensiones reales.
     return CGRect(x: x, y: y, width: width, height: height)
 }
 
 */
