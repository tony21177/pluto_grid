import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../helper/column_helper.dart';
import '../../../helper/row_helper.dart';
import '../../../mock/mock_on_change_listener.dart';
import 'column_state_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<PlutoGridScrollController>(returnNullOnMissingStub: true),
  MockSpec<LinkedScrollControllerGroup>(returnNullOnMissingStub: true),
  MockSpec<ScrollController>(returnNullOnMissingStub: true),
  MockSpec<ScrollPosition>(returnNullOnMissingStub: true),
  MockSpec<PlutoGridEventManager>(returnNullOnMissingStub: true),
])
void main() {
  final PlutoGridScrollController scroll = MockPlutoGridScrollController();
  final LinkedScrollControllerGroup horizontal =
      MockLinkedScrollControllerGroup();
  final ScrollController scrollController = MockScrollController();
  final ScrollPosition scrollPosition = MockScrollPosition();
  final PlutoGridEventManager eventManager = MockPlutoGridEventManager();

  when(scroll.horizontal).thenReturn(horizontal);
  when(scroll.horizontalOffset).thenReturn(0);
  when(scroll.maxScrollHorizontal).thenReturn(0);
  when(scroll.bodyRowsHorizontal).thenReturn(scrollController);
  when(scrollController.hasClients).thenReturn(true);
  when(scrollController.offset).thenReturn(0);
  when(scrollController.position).thenReturn(scrollPosition);
  when(scrollPosition.viewportDimension).thenReturn(0.0);
  when(scrollPosition.hasViewportDimension).thenReturn(true);

  PlutoGridStateManager getStateManager({
    required List<PlutoColumn> columns,
    required List<PlutoRow> rows,
    required FocusNode? gridFocusNode,
    required PlutoGridScrollController scroll,
    List<PlutoColumnGroup>? columnGroups,
    PlutoGridConfiguration? configuration,
  }) {
    return PlutoGridStateManager(
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
      gridFocusNode: gridFocusNode,
      scroll: scroll,
      configuration: configuration,
    )..setEventManager(eventManager);
  }

  testWidgets('columnIndexes - columns ??? ?????? index list ??? ?????? ????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<int> result = stateManager.columnIndexes;

    // then
    expect(result.length, 3);
    expect(result, [0, 1, 2]);
  });

  testWidgets('columnIndexesForShowFrozen - ?????? ?????? ????????? ?????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
        ),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<int> result = stateManager.columnIndexesForShowFrozen;

    // then
    expect(result.length, 3);
    expect(result, [2, 1, 0]);
  });

  testWidgets('columnsWidth - ?????? ?????? ????????? ?????? ?????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          width: 150,
        ),
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          width: 200,
        ),
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          width: 250,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final double result = stateManager.columnsWidth;

    // then
    expect(result, 600);
  });

  testWidgets('leftFrozenColumns - ?????? ?????? ?????? ???????????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'left1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
        ),
        PlutoColumn(title: 'body', field: '', type: PlutoColumnType.text()),
        PlutoColumn(
          title: 'left2',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<PlutoColumn> result = stateManager.leftFrozenColumns;

    // then
    expect(result.length, 2);
    expect(result[0].title, 'left1');
    expect(result[1].title, 'left2');
  });

  testWidgets('leftFrozenColumnIndexes - ?????? ?????? ?????? ????????? ???????????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'right1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
        ),
        PlutoColumn(title: 'body', field: '', type: PlutoColumnType.text()),
        PlutoColumn(
          title: 'left2',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<int> result = stateManager.leftFrozenColumnIndexes;

    // then
    expect(result.length, 1);
    expect(result[0], 2);
  });

  testWidgets('leftFrozenColumnsWidth - ?????? ?????? ?????? ?????? ????????? ???????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'right1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        PlutoColumn(
          title: 'body',
          field: '',
          type: PlutoColumnType.text(),
          width: 150,
        ),
        PlutoColumn(
          title: 'left2',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final double result = stateManager.leftFrozenColumnsWidth;

    // then
    expect(result, 300);
  });

  testWidgets('rightFrozenColumns - ????????? ?????? ?????? ???????????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'left1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
        ),
        PlutoColumn(title: 'body', field: '', type: PlutoColumnType.text()),
        PlutoColumn(
          title: 'right1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<PlutoColumn> result = stateManager.rightFrozenColumns;

    // then
    expect(result.length, 1);
    expect(result[0].title, 'right1');
  });

  testWidgets('rightFrozenColumnIndexes - ????????? ?????? ?????? ????????? ???????????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'right1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
        ),
        PlutoColumn(title: 'body', field: '', type: PlutoColumnType.text()),
        PlutoColumn(
          title: 'right2',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<int> result = stateManager.rightFrozenColumnIndexes;

    // then
    expect(result.length, 2);
    expect(result[0], 0);
    expect(result[1], 2);
  });

  testWidgets('rightFrozenColumnsWidth - ????????? ?????? ?????? ?????? ????????? ???????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'right1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
          width: 120,
        ),
        PlutoColumn(
          title: 'right2',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
          width: 120,
        ),
        PlutoColumn(
          title: 'body',
          field: '',
          type: PlutoColumnType.text(),
          width: 100,
        ),
        PlutoColumn(
          title: 'left1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 120,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final double result = stateManager.rightFrozenColumnsWidth;

    // then
    expect(result, 240);
  });

  testWidgets('bodyColumns - body ?????? ???????????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        ...ColumnHelper.textColumn('left',
            count: 3, frozen: PlutoColumnFrozen.start),
        ...ColumnHelper.textColumn('body', count: 3),
        ...ColumnHelper.textColumn('right',
            count: 3, frozen: PlutoColumnFrozen.end),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    stateManager.setLayout(const BoxConstraints(maxWidth: 1800));

    // when
    final List<PlutoColumn> result = stateManager.bodyColumns;

    // then
    expect(result.length, 3);
    expect(result[0].title, 'body0');
    expect(result[1].title, 'body1');
    expect(result[2].title, 'body2');
  });

  testWidgets('bodyColumnIndexes - body ?????? ????????? ???????????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        ...ColumnHelper.textColumn('left',
            count: 3, frozen: PlutoColumnFrozen.start),
        ...ColumnHelper.textColumn('body', count: 3),
        ...ColumnHelper.textColumn('right',
            count: 3, frozen: PlutoColumnFrozen.end),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<int> result = stateManager.bodyColumnIndexes;

    // then
    expect(result.length, 3);
    expect(result[0], 3);
    expect(result[1], 4);
    expect(result[2], 5);
  });

  testWidgets('bodyColumnsWidth - body ?????? ?????? ????????? ???????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        ...ColumnHelper.textColumn('left',
            count: 3, frozen: PlutoColumnFrozen.start),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn('right',
            count: 3, frozen: PlutoColumnFrozen.end),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final double result = stateManager.bodyColumnsWidth;

    // then
    expect(result, 450);
  });

  testWidgets('currentColumn - currentColumnField ?????? ?????? ?????? null ??? ???????????? ??????.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        ...ColumnHelper.textColumn('left',
            count: 3, frozen: PlutoColumnFrozen.start),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn('right',
            count: 3, frozen: PlutoColumnFrozen.end),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    PlutoColumn? currentColumn = stateManager.currentColumn;

    // when
    expect(currentColumn, null);
  });

  testWidgets('currentColumn - currentCell ??? ?????? ??? ?????? currentColumn ??? ???????????? ??????.',
      (WidgetTester tester) async {
    // given
    List<PlutoColumn> columns = [
      ...ColumnHelper.textColumn('left',
          count: 3, frozen: PlutoColumnFrozen.start),
      ...ColumnHelper.textColumn('body', count: 3, width: 150),
      ...ColumnHelper.textColumn('right',
          count: 3, frozen: PlutoColumnFrozen.end),
    ];

    List<PlutoRow> rows = RowHelper.count(10, columns);

    PlutoGridStateManager stateManager = getStateManager(
      columns: columns,
      rows: rows,
      gridFocusNode: null,
      scroll: scroll,
    );

    stateManager.setLayout(
      const BoxConstraints(maxWidth: 1000, maxHeight: 600),
    );

    // when
    String selectColumnField = 'body2';
    stateManager.setCurrentCell(rows[2].cells[selectColumnField], 2);

    PlutoColumn currentColumn = stateManager.currentColumn!;

    // when
    expect(currentColumn, isNot(null));
    expect(currentColumn.field, selectColumnField);
    expect(currentColumn.width, 150);
  });

  testWidgets('currentColumnField - currentCell ??? ???????????? ?????? ?????? null ??? ???????????? ??????.',
      (WidgetTester tester) async {
    // given
    List<PlutoColumn> columns = [
      ...ColumnHelper.textColumn('left',
          count: 3, frozen: PlutoColumnFrozen.start),
      ...ColumnHelper.textColumn('body', count: 3, width: 150),
      ...ColumnHelper.textColumn('right',
          count: 3, frozen: PlutoColumnFrozen.end),
    ];

    List<PlutoRow> rows = RowHelper.count(10, columns);

    PlutoGridStateManager stateManager = getStateManager(
      columns: columns,
      rows: rows,
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    String? currentColumnField = stateManager.currentColumnField;

    // when
    expect(currentColumnField, null);
  });

  testWidgets(
      'currentColumnField - currentCell ??? ?????? ??? ?????? ?????? ??? ????????? field ??? ???????????? ??????.',
      (WidgetTester tester) async {
    // given
    List<PlutoColumn> columns = [
      ...ColumnHelper.textColumn('left',
          count: 3, frozen: PlutoColumnFrozen.start),
      ...ColumnHelper.textColumn('body', count: 3, width: 150),
      ...ColumnHelper.textColumn('right',
          count: 3, frozen: PlutoColumnFrozen.end),
    ];

    List<PlutoRow> rows = RowHelper.count(10, columns);

    PlutoGridStateManager stateManager = getStateManager(
      columns: columns,
      rows: rows,
      gridFocusNode: null,
      scroll: scroll,
    );

    stateManager.setLayout(const BoxConstraints());

    // when
    String selectColumnField = 'body1';
    stateManager.setCurrentCell(rows[2].cells[selectColumnField], 2);

    String? currentColumnField = stateManager.currentColumnField;

    // when
    expect(currentColumnField, isNot(null));
    expect(currentColumnField, selectColumnField);
  });

  group('getSortedColumn', () {
    test('Sort ????????? ?????? ?????? null ??? ???????????? ??????.', () {
      final columns = ColumnHelper.textColumn('title', count: 3);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      expect(stateManager.getSortedColumn, null);
    });

    test('Sort ????????? ?????? ?????? sort ??? ????????? ???????????? ??????.', () {
      final columns = ColumnHelper.textColumn('title', count: 3);
      columns[1].sort = PlutoColumnSort.ascending;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      expect(stateManager.getSortedColumn!.key, columns[1].key);
    });
  });

  group('columnIndexesByShowFrozen', () {
    testWidgets(
        '?????? ????????? ?????? ???????????? '
        'columnIndexes ??? ?????? ????????? ??????.', (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints());

      // when
      // then
      expect(stateManager.columnIndexesByShowFrozen, [0, 1, 2]);
    });

    testWidgets(
        '?????? ????????? ?????? ???????????? '
        '3??? ??? ????????? ?????? ?????? ?????? ?????? '
        '????????? ????????? ?????? '
        'columnIndexesForShowFrozen ??? ?????? ????????? ??????.', (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('body', count: 5, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 1000, maxHeight: 600),
      );

      // when
      stateManager.toggleFrozenColumn(columns[2], PlutoColumnFrozen.start);

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 1000, maxHeight: 600),
      );

      // then
      expect(stateManager.showFrozenColumn, true);
      expect(stateManager.columnIndexesByShowFrozen, [2, 0, 1, 3, 4]);
    });

    testWidgets(
        '?????? ????????? ?????? ???????????? '
        '3??? ??? ????????? ?????? ?????? ?????? ?????? '
        '????????? ???????????? ?????? ?????? '
        'columnIndexes ??? ?????? ????????? ??????.', (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('body', count: 5, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 300, maxHeight: 600),
      );

      // when
      stateManager.toggleFrozenColumn(columns[2], PlutoColumnFrozen.start);

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 300, maxHeight: 600),
      );

      // then
      expect(stateManager.columnIndexesByShowFrozen, [0, 1, 2, 3, 4]);
    });

    testWidgets(
        '?????? ????????? ?????? ???????????? '
        '????????? ????????? ?????? '
        'columnIndexes ??? ?????? ????????? ??????.', (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 1,
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn(
          'right',
          count: 1,
          frozen: PlutoColumnFrozen.end,
          width: 150,
        ),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager
          .setLayout(const BoxConstraints(maxWidth: 500, maxHeight: 600));

      // when
      // then
      expect(stateManager.columnIndexesByShowFrozen, [0, 1, 2, 3, 4]);
    });

    testWidgets(
        '?????? ????????? ?????? ???????????? '
        '?????? ?????? ????????? ???????????? ?????? ????????????  '
        '????????? ????????? ?????? '
        'columnIndexesForShowFrozen ??? ?????? ????????? ??????.', (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 1,
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn(
          'right',
          count: 1,
          frozen: PlutoColumnFrozen.end,
          width: 150,
        ),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 700, maxHeight: 600),
      );

      stateManager.toggleFrozenColumn(columns[2], PlutoColumnFrozen.start);

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 700, maxHeight: 600),
      );

      // when
      // then
      expect(stateManager.columnIndexesByShowFrozen, [0, 2, 1, 3, 4]);
    });

    testWidgets(
        '?????? ????????? ?????? ???????????? '
        '?????? ?????? ????????? ???????????? ????????? ????????????  '
        '????????? ????????? ?????? '
        'columnIndexesForShowFrozen ??? ?????? ????????? ??????.', (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 1,
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn(
          'right',
          count: 1,
          frozen: PlutoColumnFrozen.end,
          width: 150,
        ),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 700, maxHeight: 600),
      );

      stateManager.toggleFrozenColumn(columns[2], PlutoColumnFrozen.end);

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 700, maxHeight: 600),
      );

      // when
      // then
      expect(stateManager.columnIndexesByShowFrozen, [0, 1, 3, 2, 4]);
    });
  });

  testWidgets(
    '?????? ????????? ?????? ????????? ????????? ????????? ?????? ?????? ????????? ???????????? ????????????, '
    '?????? ?????? ????????? ?????????????????? ?????? ???????????? ????????? ?????? ?????? ????????? ??????.',
    (WidgetTester tester) async {
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 1,
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn(
          'right',
          count: 1,
          frozen: PlutoColumnFrozen.end,
          width: 150,
        ),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      // 150 + 200 + 150 = ?????? 500 ??????
      stateManager
          .setLayout(const BoxConstraints(maxWidth: 550, maxHeight: 600));

      expect(stateManager.showFrozenColumn, true);
      expect(columns.first.width, 150);

      // ?????? ???????????? ?????? 50 ?????? ????????? ??????
      stateManager.resizeColumn(columns.first, 60);

      expect(stateManager.showFrozenColumn, true);
      expect(columns.first.width, 150);
    },
  );

  testWidgets(
    '?????? ????????? ????????? ????????? ?????? ?????? ????????? ?????????, '
    '?????? ?????? ?????? ????????? ????????? ??????.',
    (WidgetTester tester) async {
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 1,
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn(
          'right',
          count: 1,
          frozen: PlutoColumnFrozen.end,
          width: 150,
        ),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      // 150 + 200 + 150 = ?????? 500 ??????
      stateManager.setLayout(
        const BoxConstraints(maxWidth: 450, maxHeight: 600),
      );

      expect(stateManager.showFrozenColumn, false);
      expect(stateManager.columns[0].frozen, PlutoColumnFrozen.none);
      expect(stateManager.columns[1].frozen, PlutoColumnFrozen.none);
      expect(stateManager.columns[2].frozen, PlutoColumnFrozen.none);
      expect(stateManager.columns[3].frozen, PlutoColumnFrozen.none);
      expect(stateManager.columns[4].frozen, PlutoColumnFrozen.none);
    },
  );

  group('toggleFrozenColumn', () {
    test(
        'columnSizeConfig.restoreAutoSizeAfterFrozenColumn ??? false ???, '
        'activatedColumnsAutoSize ??? false ??? ?????? ????????? ??????.', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
            restoreAutoSizeAfterFrozenColumn: false,
          ),
        ),
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 450, maxHeight: 600),
      );

      expect(stateManager.activatedColumnsAutoSize, true);

      stateManager.toggleFrozenColumn(columns.first, PlutoColumnFrozen.start);

      expect(stateManager.activatedColumnsAutoSize, false);
    });
  });

  group('insertColumns', () {
    testWidgets(
      '?????? ????????? ?????? ???????????? 0??? ???????????? ?????? 1?????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
        const columnIdxToInsert = 0;

        final List<PlutoColumn> columnsToInsert = ColumnHelper.textColumn(
          'column',
          count: 1,
        );

        final List<PlutoColumn> columns = [];

        final List<PlutoRow> rows = [];

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.insertColumns(columnIdxToInsert, columnsToInsert);

        expect(stateManager.refColumns.length, 1);
      },
    );

    testWidgets(
      '?????? ?????? 1??? ?????? ???????????? 0??? ???????????? ?????? 1?????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
        const columnIdxToInsert = 0;

        final List<PlutoColumn> columnsToInsert = ColumnHelper.textColumn(
          'column',
          count: 1,
          start: 1,
        );

        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 1,
          start: 0,
        );

        final List<PlutoRow> rows = [];

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.insertColumns(columnIdxToInsert, columnsToInsert);

        expect(stateManager.refColumns.length, 2);

        expect(stateManager.refColumns[0].key, columnsToInsert[0].key);
      },
    );

    testWidgets(
      '?????? ?????? 1??? ?????? ???????????? ????????? ????????? ?????? ?????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
        const columnIdxToInsert = 0;

        const defaultValue = 'inserted column';

        final List<PlutoColumn> columnsToInsert = ColumnHelper.textColumn(
          'column',
          count: 1,
          start: 1,
          defaultValue: defaultValue,
        );

        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 1,
          start: 0,
        );

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.insertColumns(columnIdxToInsert, columnsToInsert);

        expect(
          stateManager.refRows[0].cells['column1']!.value,
          defaultValue,
        );

        expect(
          stateManager.refRows[1].cells['column1']!.value,
          defaultValue,
        );
      },
    );

    test(
        'columnSizeConfig.restoreAutoSizeAfterInsertColumn ??? false ???, '
        'activatedColumnsAutoSize ??? false ??? ?????? ????????? ??????.', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
            restoreAutoSizeAfterInsertColumn: false,
          ),
        ),
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 450, maxHeight: 600),
      );

      expect(stateManager.activatedColumnsAutoSize, true);

      stateManager.insertColumns(0, ColumnHelper.textColumn('title'));

      expect(stateManager.activatedColumnsAutoSize, false);
    });
  });

  group('removeColumns', () {
    testWidgets(
      '0??? ????????? ???????????? ????????? ??????????????? ??????.',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.removeColumns([columns[0]]);

        expect(stateManager.refColumns.length, 9);
      },
    );

    testWidgets(
      '0??? ????????? ???????????? ?????? ????????? ?????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        expect(stateManager.refRows[0].cells.entries.length, 10);

        stateManager.removeColumns([columns[0]]);

        expect(stateManager.refRows[0].cells.entries.length, 9);
      },
    );

    testWidgets(
      '8, 8??? ????????? ???????????? ?????? ????????? ?????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        expect(stateManager.refRows[0].cells.entries.length, 10);

        stateManager.removeColumns([columns[8], columns[9]]);

        expect(stateManager.refRows[0].cells.entries.length, 8);
      },
    );

    testWidgets(
      '?????? ????????? ?????? ???????????? ????????? ???????????? ??? ????????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoColumnGroup> columnGroups = [
          PlutoColumnGroup(title: 'a', fields: ['column0']),
          PlutoColumnGroup(
              title: 'b',
              fields: columns
                  .where((element) => element.field != 'column0')
                  .map((e) => e.field)
                  .toList()),
        ];

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          columnGroups: columnGroups,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.removeColumns([columns[0]]);

        expect(stateManager.columnGroups.length, 1);

        expect(stateManager.columnGroups[0].title, 'b');
      },
    );

    testWidgets(
      '?????? ????????? ?????? ???????????? ????????? ???????????? ?????? ???????????? ????????? ??????????????? ??????.',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoColumnGroup> columnGroups = [
          PlutoColumnGroup(title: 'a', fields: ['column0']),
          PlutoColumnGroup(
              title: 'b',
              fields: columns
                  .where((element) => element.field != 'column0')
                  .map((e) => e.field)
                  .toList()),
        ];

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          columnGroups: columnGroups,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.removeColumns([columns[1]]);

        expect(stateManager.columnGroups.length, 2);

        expect(
          stateManager.columnGroups[1].fields!.contains('column1'),
          false,
        );

        expect(stateManager.columnGroups[1].fields!.length, 8);
      },
    );

    testWidgets(
      '?????? ?????? ????????? ?????? ???????????? ????????? ???????????? ??? ?????? ?????? ????????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoColumnGroup> columnGroups = [
          PlutoColumnGroup(title: 'a', fields: ['column0']),
          PlutoColumnGroup(
            title: 'b',
            children: [
              PlutoColumnGroup(title: 'c', fields: ['column1']),
              PlutoColumnGroup(
                  title: 'd',
                  fields: columns
                      .where((element) =>
                          !['column0', 'column1'].contains(element.field))
                      .map((e) => e.field)
                      .toList()),
            ],
          ),
        ];

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          columnGroups: columnGroups,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        expect(stateManager.columnGroups[1].children!.length, 2);

        stateManager.removeColumns([columns[1]]);

        expect(stateManager.columnGroups[1].children!.length, 1);

        expect(stateManager.columnGroups[1].children![0].title, 'd');
      },
    );

    testWidgets(
      '????????? ?????? ????????? ?????? ??? ?????? ?????? ????????? ????????? ?????? ????????? ??????.',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        final List<PlutoRow> filterRows = [
          FilterHelper.createFilterRow(
            columnField: columns[0].field,
            filterType: const PlutoFilterTypeContains(),
            filterValue: 'filter',
          ),
          FilterHelper.createFilterRow(
            columnField: columns[0].field,
            filterType: const PlutoFilterTypeContains(),
            filterValue: 'filter',
          ),
        ];

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.setFilterWithFilterRows(filterRows);

        expect(stateManager.filterRows.length, 2);

        stateManager.removeColumns([columns[0]]);

        expect(stateManager.filterRows.length, 0);
      },
    );

    test(
        'columnSizeConfig.restoreAutoSizeAfterRemoveColumn ??? false ???, '
        'activatedColumnsAutoSize ??? false ??? ?????? ????????? ??????.', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
            restoreAutoSizeAfterRemoveColumn: false,
          ),
        ),
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 450, maxHeight: 600),
      );

      expect(stateManager.activatedColumnsAutoSize, true);

      stateManager.removeColumns([columns.first]);

      expect(stateManager.activatedColumnsAutoSize, false);
    });
  });

  group('moveColumn', () {
    test('?????? ?????? ???????????? ??????????????? ???????????? notifyListeners ??? ?????? ?????? ????????? ??????.', () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 500));

      final listeners = MockOnChangeListener();

      stateManager.addListener(listeners.onChangeVoidNoParamListener);

      final column = columns[0];

      final targetColumn = columns[1]..frozen = PlutoColumnFrozen.start;

      stateManager.moveColumn(
        column: column,
        targetColumn: targetColumn,
      );

      verifyNever(listeners.onChangeVoidNoParamListener());
    });

    test('?????? ?????? ????????? ???????????? notifyListeners ??? ?????? ????????? ??????.', () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 500));

      final listeners = MockOnChangeListener();

      stateManager.addListener(listeners.onChangeVoidNoParamListener);

      final column = columns[0]..width = 50;

      final targetColumn = columns[1]..frozen = PlutoColumnFrozen.start;

      stateManager.moveColumn(
        column: column,
        targetColumn: targetColumn,
      );

      verify(listeners.onChangeVoidNoParamListener()).called(1);
    });

    test('0 ??? ????????? ????????? 4??? ?????? ?????? ???????????? ?????? ????????? ?????? ????????? ???????????? ??????.', () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      columns[0].frozen = PlutoColumnFrozen.none;
      columns[1].frozen = PlutoColumnFrozen.none;
      columns[2].frozen = PlutoColumnFrozen.start;
      columns[3].frozen = PlutoColumnFrozen.start;
      columns[4].frozen = PlutoColumnFrozen.end;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 1200));

      stateManager.moveColumn(
        column: columns[0],
        targetColumn: columns[4],
      );

      expect(stateManager.refColumns[0].title, 'title1');
      expect(stateManager.refColumns[1].title, 'title2');
      expect(stateManager.refColumns[2].title, 'title3');
      expect(stateManager.refColumns[3].title, 'title4');
      expect(stateManager.refColumns[4].title, 'title0');
    });

    test('4 ??? ????????? ????????? 1??? ?????? ?????? ???????????? ?????? ????????? ?????? ????????? ???????????? ??????.', () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      columns[0].frozen = PlutoColumnFrozen.none;
      columns[1].frozen = PlutoColumnFrozen.start;
      columns[2].frozen = PlutoColumnFrozen.none;
      columns[3].frozen = PlutoColumnFrozen.none;
      columns[4].frozen = PlutoColumnFrozen.none;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 1200));

      stateManager.moveColumn(
        column: columns[4],
        targetColumn: columns[1],
      );

      expect(stateManager.refColumns[0].title, 'title0');
      expect(stateManager.refColumns[1].title, 'title4');
      expect(stateManager.refColumns[2].title, 'title1');
      expect(stateManager.refColumns[3].title, 'title2');
      expect(stateManager.refColumns[4].title, 'title3');
    });

    test('3??? ?????? ????????? 1??? ????????? ???????????? ?????? ????????? ?????? ????????? ???????????? ??????.', () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      columns[0].frozen = PlutoColumnFrozen.none;
      columns[1].frozen = PlutoColumnFrozen.none;
      columns[2].frozen = PlutoColumnFrozen.none;
      columns[3].frozen = PlutoColumnFrozen.start;
      columns[4].frozen = PlutoColumnFrozen.none;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 1200));

      stateManager.moveColumn(
        column: columns[3],
        targetColumn: columns[1],
      );

      // 3?????? ?????? ?????? ???????????? 1??? ?????? ????????? ??????.
      // 3??? ????????? 1??? ?????? ???????????? ???????????? 1??? ????????? ?????? 3?????? ????????????
      // 3?????? 1?????? ????????? ????????????.
      expect(stateManager.refColumns[0].title, 'title0');
      expect(stateManager.refColumns[1].title, 'title1');
      expect(stateManager.refColumns[2].title, 'title3');
      expect(stateManager.refColumns[3].title, 'title2');
      expect(stateManager.refColumns[4].title, 'title4');
    });

    test('1??? ?????? ????????? 4??? ????????? ???????????? ?????? ????????? ?????? ????????? ???????????? ??????.', () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      columns[0].frozen = PlutoColumnFrozen.none;
      columns[1].frozen = PlutoColumnFrozen.end;
      columns[2].frozen = PlutoColumnFrozen.none;
      columns[3].frozen = PlutoColumnFrozen.none;
      columns[4].frozen = PlutoColumnFrozen.none;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 1200));

      stateManager.moveColumn(
        column: columns[1],
        targetColumn: columns[4],
      );

      // 1?????? ?????? ?????? ?????? 4??? ?????? ????????? ?????? ????????????
      // 1?????? 4??? ????????? ?????? 4?????? 1??? ????????? ???????????? ??????.
      expect(stateManager.refColumns[0].title, 'title0');
      expect(stateManager.refColumns[1].title, 'title2');
      expect(stateManager.refColumns[2].title, 'title3');
      expect(stateManager.refColumns[3].title, 'title1');
      expect(stateManager.refColumns[4].title, 'title4');
    });

    test(
        'columnSizeConfig.restoreAutoSizeAfterMoveColumn ??? false ???, '
        'activatedColumnsAutoSize ??? false ??? ?????? ????????? ??????.', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
            restoreAutoSizeAfterMoveColumn: false,
          ),
        ),
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 450, maxHeight: 600),
      );

      expect(stateManager.activatedColumnsAutoSize, true);

      stateManager.moveColumn(
        column: columns.first,
        targetColumn: columns.last,
      );

      expect(stateManager.activatedColumnsAutoSize, false);
    });
  });

  group('resizeColumn', () {
    test('columnsResizeMode.isNone ?????? notifyResizingListeners ??? ?????? ?????? ????????? ??????.',
        () {
      final columns = ColumnHelper.textColumn('title', count: 5);
      final mockListener = MockOnChangeListener();

      PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
              resizeMode: PlutoResizeMode.none,
            ),
          ));

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      stateManager.resizingChangeNotifier.addListener(
        mockListener.onChangeVoidNoParamListener,
      );

      stateManager.resizeColumn(columns.first, 10);

      verifyNever(mockListener.onChangeVoidNoParamListener());

      stateManager.resizingChangeNotifier.removeListener(
        mockListener.onChangeVoidNoParamListener,
      );
    });

    test(
        'column.enableDropToResize ??? false ?????? notifyResizingListeners ??? ?????? ?????? ????????? ??????.',
        () {
      final columns = ColumnHelper.textColumn('title', count: 5);
      final mockListener = MockOnChangeListener();

      PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
              resizeMode: PlutoResizeMode.normal,
            ),
          ));

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      stateManager.resizingChangeNotifier.addListener(
        mockListener.onChangeVoidNoParamListener,
      );

      stateManager.resizeColumn(columns.first..enableDropToResize = false, 10);

      verifyNever(mockListener.onChangeVoidNoParamListener());

      stateManager.resizingChangeNotifier.removeListener(
        mockListener.onChangeVoidNoParamListener,
      );
    });

    test('offset 10 ?????? ????????? ????????? ???????????? ??????.', () {
      final columns = ColumnHelper.textColumn('title', count: 5);
      final mockListener = MockOnChangeListener();

      PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
              resizeMode: PlutoResizeMode.normal,
            ),
          ));

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      stateManager.resizingChangeNotifier.addListener(
        mockListener.onChangeVoidNoParamListener,
      );

      expect(columns.first.width, 200);

      stateManager.resizeColumn(columns.first, 10);

      verify(mockListener.onChangeVoidNoParamListener()).called(1);
      expect(columns.first.width, 210);

      stateManager.resizingChangeNotifier.removeListener(
        mockListener.onChangeVoidNoParamListener,
      );
    });

    test(
      'PlutoResizeMode.pushAndPull ????????? scroll.horizontal.notifyListeners ?????? ????????? ??????.',
      () {
        final columns = ColumnHelper.textColumn('title', count: 5);

        PlutoGridStateManager stateManager = getStateManager(
            columns: columns,
            rows: [],
            gridFocusNode: null,
            scroll: scroll,
            configuration: const PlutoGridConfiguration(
              columnSize: PlutoGridColumnSizeConfig(
                resizeMode: PlutoResizeMode.pushAndPull,
              ),
            ));

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        reset(horizontal);

        stateManager.resizeColumn(columns.first, 10);

        verify(horizontal.notifyListeners()).called(1);
      },
    );
  });

  group('autoFitColumn', () {
    testWidgets('?????? ?????? ?????? ?????? ?????? ???????????? ?????? ?????? ?????? ????????? ?????? ????????? ??????.', (tester) async {
      final columns = ColumnHelper.textColumn('title');

      final rows = RowHelper.count(3, columns);
      rows[0].cells['title0']!.value = 'a';
      rows[1].cells['title0']!.value = 'ab';
      rows[2].cells['title0']!.value = 'abc';

      late final BuildContext context;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (builderContext) {
                context = builderContext;
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: PlutoBaseColumn(
                    stateManager: stateManager,
                    column: columns.first,
                  ),
                );
              },
            ),
          ),
        ),
      );

      stateManager.autoFitColumn(context, columns.first);

      expect(columns.first.width, columns.first.minWidth);
    });

    testWidgets('?????? ?????? ?????? ?????? ?????? ???????????? ??? ?????? ?????? ?????? ???????????? ?????? ????????? ??????.',
        (tester) async {
      final columns = ColumnHelper.textColumn('title');

      final rows = RowHelper.count(3, columns);
      rows[0].cells['title0']!.value = 'a';
      rows[1].cells['title0']!.value = 'ab';
      rows[2].cells['title0']!.value = 'abc abc abc';

      late final BuildContext context;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (builderContext) {
                context = builderContext;
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: PlutoBaseColumn(
                    stateManager: stateManager,
                    column: columns.first,
                  ),
                );
              },
            ),
          ),
        ),
      );

      stateManager.autoFitColumn(context, columns.first);

      expect(columns.first.width, greaterThan(columns.first.minWidth));
    });
  });

  group('hideColumn', () {
    testWidgets('flag ??? true ??? ?????? ??? ?????? ????????? hide ??? true ??? ?????? ????????? ??????.',
        (WidgetTester tester) async {
      // given
      var columns = [
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
      ];

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      // when
      expect(stateManager.columns.first.hide, isFalse);

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      stateManager.hideColumn(columns.first, true);

      // then
      expect(stateManager.refColumns.originalList.first.hide, isTrue);
    });

    testWidgets(
        'hide ??? true ??? ????????? flag ??? false ??? ???????????? hide ??? false ??? ?????? ????????? ??????.',
        (WidgetTester tester) async {
      // given
      var columns = [
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          hide: true,
        ),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
      ];

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      // when
      expect(stateManager.refColumns.originalList.first.hide, isTrue);

      stateManager.hideColumn(columns.first, false);

      // then
      expect(stateManager.columns.first.hide, isFalse);
    });

    testWidgets(
      '?????? ????????? hide ??? true ??? ????????? flag ??? false ??? ?????? ??? ???, '
      '?????? ?????? ?????? ????????? ?????? ?????? ????????? ?????? ????????? ????????? ??????.',
      (WidgetTester tester) async {
        // given
        var columns = [
          PlutoColumn(
            title: '',
            field: '',
            width: 700,
            type: PlutoColumnType.text(),
            hide: true,
          ),
          PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
          PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        ];

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.columns.first.frozen = PlutoColumnFrozen.start;

        // when
        expect(stateManager.refColumns.originalList.first.hide, isTrue);

        stateManager.hideColumn(columns.first, false);

        // then
        expect(stateManager.columns.first.hide, isFalse);

        expect(stateManager.columns.first.frozen, PlutoColumnFrozen.none);
      },
    );

    testWidgets('flag ??? true ??? ?????? ??? ?????? notifyListeners ??? ?????? ????????? ??????.',
        (WidgetTester tester) async {
      // given
      var columns = [
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
      ];

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      var listeners = MockOnChangeListener();

      stateManager.addListener(listeners.onChangeVoidNoParamListener);

      // when
      expect(stateManager.columns.first.hide, isFalse);

      stateManager.hideColumn(columns.first, true);

      // then
      verify(listeners.onChangeVoidNoParamListener()).called(1);
    });

    testWidgets(
        'hide ??? false ??? ?????? flag ??? false ??? ?????? ?????? notifyListeners ??? ?????? ?????? ????????? ??????.',
        (WidgetTester tester) async {
      // given
      var columns = [
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
      ];

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      var listeners = MockOnChangeListener();

      stateManager.addListener(listeners.onChangeVoidNoParamListener);

      // when
      expect(stateManager.columns.first.hide, isFalse);

      stateManager.hideColumn(columns.first, false);

      // then
      verifyNever(listeners.onChangeVoidNoParamListener());
    });
  });

  group('hideColumns', () {
    test('columns ??? empty ??? notifyListeners ??? ?????? ?????? ????????? ??????.', () async {
      final columns = <PlutoColumn>[];

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      var listeners = MockOnChangeListener();

      stateManager.addListener(listeners.onChangeVoidNoParamListener);

      stateManager.hideColumns(columns, true);

      verifyNever(listeners.onChangeVoidNoParamListener());
    });

    test('columns ??? empty ??? ????????? notifyListeners ??? ?????? ????????? ??????.', () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      var listeners = MockOnChangeListener();

      stateManager.addListener(listeners.onChangeVoidNoParamListener);

      stateManager.hideColumns(columns, true);

      verify(listeners.onChangeVoidNoParamListener()).called(1);
    });

    test('hide ??? true ??? ????????? ?????? ???????????? ????????? ??????.', () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      stateManager.hideColumns(columns, true);

      final hideList = stateManager.refColumns.originalList.where(
        (element) => element.hide,
      );

      expect(hideList.length, 5);
    });

    test(
      '0, 1 ??? ????????? hide ??? false ??? ?????? ?????? ????????? ?????? ???????????? ????????? ??????.',
      () async {
        final columns = ColumnHelper.textColumn('title', count: 5, hide: true);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 1000));

        stateManager.hideColumns(columns.getRange(0, 2).toList(), false);

        // ?????? ??? ??????
        expect(columns[0].hide, false);
        expect(columns[1].hide, false);
        // ?????? ?????? ?????? ??????
        expect(columns[2].hide, true);
        expect(columns[3].hide, true);
        expect(columns[4].hide, true);
      },
    );

    test(
      '?????? ?????? ?????? ????????? ????????? ???????????? 0, 1??? ????????? hide ??? false ??? ?????? ?????? '
      'frozen ????????? none ?????? ?????? ????????? ??????.',
      () async {
        final columns = ColumnHelper.textColumn(
          'title',
          count: 5,
          hide: true,
          frozen: PlutoColumnFrozen.start,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 300));

        // setLayout ?????? ??? ?????? ????????? ????????? ?????? showFrozenColumn ??? false ??????
        // ?????? ????????? frozen ??? none ?????? ????????? ?????? ???????????? ?????? ?????? ?????? ???????????? ??????.
        for (final column in columns) {
          column.frozen = PlutoColumnFrozen.start;
        }

        stateManager.hideColumns(columns.getRange(0, 2).toList(), false);

        // ?????? ??? ??????
        expect(columns[0].hide, false);
        expect(columns[0].frozen, PlutoColumnFrozen.none);
        expect(columns[1].hide, false);
        expect(columns[1].frozen, PlutoColumnFrozen.none);
        // ?????? ?????? ?????? ??????
        expect(columns[2].hide, true);
        expect(columns[2].frozen, PlutoColumnFrozen.start);
        expect(columns[3].hide, true);
        expect(columns[3].frozen, PlutoColumnFrozen.start);
        expect(columns[4].hide, true);
        expect(columns[4].frozen, PlutoColumnFrozen.start);
      },
    );
  });

  group('limitResizeColumn', () {
    test('offset ??? 0 ?????? ????????? false ??? ???????????? ??????.', () {
      final PlutoColumn column = PlutoColumn(
        title: 'title',
        field: 'field',
        type: PlutoColumnType.text(),
      );

      const offset = -1.0;

      PlutoGridStateManager stateManager = getStateManager(
        columns: [column],
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      expect(stateManager.limitResizeColumn(column, offset), false);
    });

    test('column ??? frozen ??? none ?????? false ??? ???????????? ??????.', () {
      final PlutoColumn column = PlutoColumn(
        title: 'title',
        field: 'field',
        type: PlutoColumnType.text(),
        frozen: PlutoColumnFrozen.none,
      );

      const offset = 1.0;

      PlutoGridStateManager stateManager = getStateManager(
        columns: [column],
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      expect(stateManager.limitResizeColumn(column, offset), false);
    });

    test('?????? ????????? ????????? ?????? ?????? ???????????? offset ??? ?????? ?????? false ??? ???????????? ??????.', () {
      final PlutoColumn column = PlutoColumn(
        title: 'title',
        field: 'field',
        type: PlutoColumnType.text(),
        frozen: PlutoColumnFrozen.start,
        width: 100,
      );

      PlutoGridStateManager stateManager = getStateManager(
        columns: [
          column,
          ...ColumnHelper.textColumn('title', count: 3, width: 100),
        ],
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 500));

      // 500 - 306 = 194 ?????? ?????? ?????? ?????? ??????.
      // print(stateManager.maxWidth);
      // ?????? ?????? ?????? ?????? 100
      // print(stateManager.leftFrozenColumnsWidth);
      // ?????? ?????? ?????? ?????? 0
      // print(stateManager.rightFrozenColumnsWidth);
      // 200
      // print(PlutoGridSettings.bodyMinWidth);
      // 6
      // print(PlutoGridSettings.totalShadowLineWidth);

      expect(stateManager.limitResizeColumn(column, 193.0), false);
    });

    test('?????? ????????? ????????? ?????? ?????? ?????? ?????? ?????? offset ??? ?????? ?????? true ??? ???????????? ??????.', () {
      final PlutoColumn column = PlutoColumn(
        title: 'title',
        field: 'field',
        type: PlutoColumnType.text(),
        frozen: PlutoColumnFrozen.start,
        width: 100,
      );

      PlutoGridStateManager stateManager = getStateManager(
        columns: [
          column,
          ...ColumnHelper.textColumn('title', count: 3, width: 100),
        ],
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 500));

      // 500 - 306 = 194 ?????? ?????? ?????? ?????? ??????.
      // print(stateManager.maxWidth);
      // ?????? ?????? ?????? ?????? 100
      // print(stateManager.leftFrozenColumnsWidth);
      // ?????? ?????? ?????? ?????? 0
      // print(stateManager.rightFrozenColumnsWidth);
      // 200
      // print(PlutoGridSettings.bodyMinWidth);
      // 6
      // print(PlutoGridSettings.totalShadowLineWidth);

      expect(stateManager.limitResizeColumn(column, 194.0), true);
    });
  });

  group('limitMoveColumn', () {
    test(
      'column ??? ?????? ???????????? ?????? ?????? ?????? ????????? ?????? ?????? ???????????? false ??? ?????? ?????? ??????.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 100,
        );

        final PlutoColumn targetColumn = PlutoColumn(
          title: 'title2',
          field: 'field2',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // 500 - 406 = 94 ?????? ?????? ?????? ?????? ??????.
        // print(stateManager.maxWidth);
        // ?????? ?????? ?????? ?????? 100
        // print(stateManager.leftFrozenColumnsWidth);
        // ?????? ?????? ?????? ?????? 100
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitMoveColumn(
            column: column,
            targetColumn: targetColumn,
          ),
          false,
        );
      },
    );

    test(
      '?????? ????????? ?????? ?????? ???????????? ?????? ?????? ????????? ???????????? false ??? ?????? ?????? ??????.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 100,
        );

        final PlutoColumn targetColumn = PlutoColumn(
          title: 'title2',
          field: 'field2',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // 500 - 306 = 294 ?????? ?????? ?????? ?????? ??????.
        // print(stateManager.maxWidth);
        // ?????? ?????? ?????? ?????? 100
        // print(stateManager.leftFrozenColumnsWidth);
        // ?????? ?????? ?????? ?????? 0
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitMoveColumn(
            column: column,
            targetColumn: targetColumn,
          ),
          false,
        );
      },
    );

    test(
      '?????? ????????? ?????? ?????? ???????????? ?????? ??? ??? ?????? ?????? ????????? ???????????? false ??? ?????? ?????? ??????.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          width: 100,
        );

        final PlutoColumn targetColumn = PlutoColumn(
          title: 'title2',
          field: 'field2',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // 500 - 306 = 294 ?????? ?????? ?????? ?????? ??????.
        // print(stateManager.maxWidth);
        // ?????? ?????? ?????? ?????? 100
        // print(stateManager.leftFrozenColumnsWidth);
        // ?????? ?????? ?????? ?????? 0
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitMoveColumn(
            column: column,
            targetColumn: targetColumn,
          ),
          false,
        );
      },
    );

    test(
      '?????? ????????? ?????? ?????? ???????????? ?????? ??? ??? ?????? ?????? ????????? ???????????? true ??? ?????? ?????? ??????.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          width: 294,
        );

        final PlutoColumn targetColumn = PlutoColumn(
          title: 'title2',
          field: 'field2',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // 500 - 306 = 294 ?????? ?????? ?????? ?????? ??????.
        // print(stateManager.maxWidth! - column.width);
        // ?????? ?????? ?????? ?????? 100
        // print(stateManager.leftFrozenColumnsWidth);
        // ?????? ?????? ?????? ?????? 0
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitMoveColumn(
            column: column,
            targetColumn: targetColumn,
          ),
          true,
        );
      },
    );
  });

  group('limitToggleFrozenColumn', () {
    test(
      'column ??? frozen ??? isFrozen ?????? ?????? ????????? ??? ????????? ???????????? '
      '??????????????? ?????? ?????? false ??? ?????? ?????? ??????.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        expect(
          stateManager.limitToggleFrozenColumn(column, PlutoColumnFrozen.none),
          false,
        );
      },
    );

    test(
      'column ??? frozen ??? none ?????? frozen ???????????? ?????? ??? ???, '
      '?????? ?????? ????????? ???????????? false ??? ?????? ?????? ??????.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // 500 - 206 = 394 ?????? ?????? ?????? ?????? ??????.
        // print(stateManager.maxWidth! - column.width);
        // ?????? ?????? ?????? ?????? 0
        // print(stateManager.leftFrozenColumnsWidth);
        // ?????? ?????? ?????? ?????? 0
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitToggleFrozenColumn(column, PlutoColumnFrozen.start),
          false,
        );
      },
    );

    test(
      'column ??? frozen ??? none ?????? frozen ???????????? ?????? ??? ???, '
      '?????? ?????? ????????? ???????????? true ??? ?????? ?????? ??????.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          width: 394,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // 500 - 206 = 394 ?????? ?????? ?????? ?????? ??????.
        // print(stateManager.maxWidth! - column.width);
        // ?????? ?????? ?????? ?????? 0
        // print(stateManager.leftFrozenColumnsWidth);
        // ?????? ?????? ?????? ?????? 0
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitToggleFrozenColumn(column, PlutoColumnFrozen.start),
          true,
        );
      },
    );
  });

  group('limitHideColumn', () {
    test(
      'column ??? hide ??? true ??? ???????????? ??????????????? ??????????????? ?????? ?????? false ??? ?????? ?????? ??????.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
          width: 394,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        expect(stateManager.limitHideColumn(column, true), false);
      },
    );

    test(
      'column ??? frozen ??? none ?????? ?????? ????????? ?????? ???????????? false ??? ?????? ?????? ??????.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          hide: true,
          width: 394,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        expect(stateManager.limitHideColumn(column, false), false);
      },
    );

    test(
      '?????? ????????? ?????? ?????? ?????? ?????? ????????? ???????????? false ??? ?????? ?????? ??????.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          hide: true,
          width: 394,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // stateManager.setLayout ?????? showFrozenColumn ??? ?????? ??????
        // ????????? ????????? ?????? ????????? none ?????? ???????????? ?????? ????????? left ??? ??????.
        column.frozen = PlutoColumnFrozen.start;

        // 500 - 206 = 394 ?????? ?????? ?????? ?????? ?????? ??????.
        // print(stateManager.maxWidth! - column.width);
        // ?????? ?????? ?????? ?????? 0
        // print(stateManager.leftFrozenColumnsWidth);
        // ?????? ?????? ?????? ?????? 0
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(stateManager.limitHideColumn(column, false), true);
      },
    );
  });
}
