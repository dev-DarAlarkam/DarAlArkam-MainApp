import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirebaseUser Tests', () {
    test('toJson and fromJson', () {
      final user = FirebaseUser(
        id: '1',
        firstName: 'John',
        secondName: 'Doe',
        thirdName: 'Smith',
        birthday: '1990-01-01',
        type: 'user',
      );

      final json = user.toJson();
      final fromJson = FirebaseUser.fromJson(json);

      expect(fromJson.id, user.id);
      expect(fromJson.firstName, user.firstName);
      expect(fromJson.secondName, user.secondName);
      expect(fromJson.thirdName, user.thirdName);
      expect(fromJson.birthday, user.birthday);
      expect(fromJson.type, user.type);
    });
  });

  group('Teacher Tests', () {
    test('toJson and fromJson', () {
      final teacher = Teacher(
        id: '2',
        firstName: 'Alice',
        secondName: 'Johnson',
        thirdName: 'Brown',
        birthday: '1985-03-15',
        type: 'teacher',
        classIds: ['class1', 'class2'],
      );

      final json = teacher.toJson();
      final fromJson = Teacher.fromJson(json);

      expect(fromJson.id, teacher.id);
      expect(fromJson.firstName, teacher.firstName);
      expect(fromJson.secondName, teacher.secondName);
      expect(fromJson.thirdName, teacher.thirdName);
      expect(fromJson.birthday, teacher.birthday);
      expect(fromJson.type, teacher.type);
      expect(fromJson.classIds, teacher.classIds);
    });

    test('fromFirebaseUser', () {
      final firebaseUser = FirebaseUser(
        id: '3',
        firstName: 'Bob',
        secondName: 'Miller',
        thirdName: 'Wilson',
        birthday: '1995-05-20',
        type: 'teacher',
      );

      final teacher = Teacher.fromFirebaseUser(firebaseUser, ['class3']);

      expect(teacher.id, firebaseUser.id);
      expect(teacher.firstName, firebaseUser.firstName);
      expect(teacher.secondName, firebaseUser.secondName);
      expect(teacher.thirdName, firebaseUser.thirdName);
      expect(teacher.birthday, firebaseUser.birthday);
      expect(teacher.type, firebaseUser.type);
      expect(teacher.classIds, ['class3']);
    });
  });

  group('Student Tests', () {
    test('toJson and fromJson', () {
      final student = Student(
        id: '4',
        firstName: 'Eve',
        secondName: 'White',
        thirdName: 'Johnson',
        birthday: '2000-08-10',
        type: 'student',
        classId: 'class4',
      );

      final json = student.toJson();
      final fromJson = Student.fromJson(json);

      expect(fromJson.id, student.id);
      expect(fromJson.firstName, student.firstName);
      expect(fromJson.secondName, student.secondName);
      expect(fromJson.thirdName, student.thirdName);
      expect(fromJson.birthday, student.birthday);
      expect(fromJson.type, student.type);
      expect(fromJson.classId, student.classId);
    });

    test('fromFirebaseUser', () {
      final firebaseUser = FirebaseUser(
        id: '5',
        firstName: 'Grace',
        secondName: 'Anderson',
        thirdName: 'Smith',
        birthday: '2005-12-25',
        type: 'student',
      );

      final student = Student.fromFirebaseUser(firebaseUser, 'class5');

      expect(student.id, firebaseUser.id);
      expect(student.firstName, firebaseUser.firstName);
      expect(student.secondName, firebaseUser.secondName);
      expect(student.thirdName, firebaseUser.thirdName);
      expect(student.birthday, firebaseUser.birthday);
      expect(student.type, firebaseUser.type);
      expect(student.classId, 'class5');
    });
  });

  group('Supervisor Tests', () {
    test('toJson and fromJson', () {
      final supervisor = Supervisor(
        id: '6',
        firstName: 'Michael',
        secondName: 'Brown',
        thirdName: 'Davis',
        birthday: '1978-02-28',
        type: 'supervisor',
        classIds: ['class6'],
        teacherIds: ['teacher1', 'teacher2'],
      );

      final json = supervisor.toJson();
      final fromJson = Supervisor.fromJson(json);

      expect(fromJson.id, supervisor.id);
      expect(fromJson.firstName, supervisor.firstName);
      expect(fromJson.secondName, supervisor.secondName);
      expect(fromJson.thirdName, supervisor.thirdName);
      expect(fromJson.birthday, supervisor.birthday);
      expect(fromJson.type, supervisor.type);
      expect(fromJson.classIds, supervisor.classIds);
      expect(fromJson.teacherIds, supervisor.teacherIds);
    });

    test('fromFirebaseUser', () {
      final firebaseUser = FirebaseUser(
        id: '7',
        firstName: 'Sarah',
        secondName: 'Wilson',
        thirdName: 'Lee',
        birthday: '1983-11-15',
        type: 'supervisor',
      );

      final supervisor = Supervisor.fromFirebaseUser(firebaseUser, ['class7'], ['teacher3']);

      expect(supervisor.id, firebaseUser.id);
      expect(supervisor.firstName, firebaseUser.firstName);
      expect(supervisor.secondName, firebaseUser.secondName);
      expect(supervisor.thirdName, firebaseUser.thirdName);
      expect(supervisor.birthday, firebaseUser.birthday);
      expect(supervisor.type, firebaseUser.type);
      expect(supervisor.classIds, ['class7']);
      expect(supervisor.teacherIds, ['teacher3']);
    });
  });
}
