//
//  CalendarModule.swift
//  chatgpt_v2
//
//  Created by 신영재 on 2023/05/17.
//
import SwiftUI
import FSCalendar

class CalendarModule: UIViewController, FSCalendarDelegate {
    
    var calendar = FSCalendar()
    @Binding var selectedDate: Date?
    var events:[Date] = []
    init(selectedDate: Binding<Date?>) {
            self._selectedDate = selectedDate
            super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.allowsSelection = true

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initCalendar()
        view.addSubview(calendar)
    }
    
    private func initCalendar() {
        calendar.delegate = self
        calendar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        calendar.appearance.todayColor = UIColor(Color.mainColor)
        calendar.appearance.selectionColor = UIColor(Color.yellow)
        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.eventSelectionColor = UIColor.green
    }
//    func setEvents() {
//        let dfMatter = DateFormatter()
//        dfMatter.locale = Locale(identifier: "ko_KR")
//        dfMatter.dateFormat = "yyyy-MM-dd"
//
//        // events
//        let myFirstEvent = dfMatter.date(from: "2022-05-01")
//        let mySecondEvent = dfMatter.date(from: "2022-05-15")
//        events = [myFirstEvent!, mySecondEvent!]
//
//    }
    
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]?
//    {
//        
//    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
    }

}

struct CalendarModuleViewController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    @Binding var selectedDate: Date?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CalendarModuleViewController>) -> UIViewController {
        let viewController = CalendarModule(selectedDate: $selectedDate)
//        viewController.selectedDateBinding = selectedDate.wrappedValue
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CalendarModuleViewController>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, FSCalendarDelegate {
        private var parent: CalendarModuleViewController
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }

        init (_ parent: CalendarModuleViewController) {
            self.parent = parent
        }
        
    }
}


struct CalendarModuleView: View {
    @Binding var selectedDate: Date?
    var body: some View {
        CalendarModuleViewController(selectedDate: $selectedDate)
    }
    
}

