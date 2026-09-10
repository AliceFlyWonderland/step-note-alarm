// 구창모 《방황》 셔플 댄스 110박 루틴 데이터
// 출처: ✅구창모-방황-셔플노트.md (대한셔플댄스협회, 안무가 shuffle_jiyoung)
// 128 BPM, 4/4박자, 1박 = 0.46875초 (미검증 추정 타임코드 - 실제 음원으로 보정 필요)

class RoutineStep {
  final String id;
  final String fullName; // 전체 이름
  final String bigLabel; // 멀리서도 보이는 큰 약칭
  final int startBeat; // 1-indexed, inclusive
  final int endBeat; // inclusive
  final int difficulty; // 1~5 (★ 히트맵용, 대부분 휴리스틱 추정치)
  final String guide; // 실행 가이드 요약
  final String part; // A, B, C

  const RoutineStep({
    required this.id,
    required this.fullName,
    required this.bigLabel,
    required this.startBeat,
    required this.endBeat,
    required this.difficulty,
    required this.guide,
    required this.part,
  });

  int get beatCount => endBeat - startBeat + 1;
}

class BeatCue {
  final int beat; // 1~110
  final double startSec;
  final double endSec;
  final String musicNote; // 악기/리듬 악센트 (추정)
  final String footCue; // 발 동작 세부 지시
  final String stepId;
  final String? lyricFragment; // 이 박에서 시작되는 보컬 조각 (있을 경우)
  final bool spinFlag; // 스핀턴 표시 플래그
  final bool endingFlag; // 엔딩 포즈 표시 플래그

  const BeatCue({
    required this.beat,
    required this.startSec,
    required this.endSec,
    required this.musicNote,
    required this.footCue,
    required this.stepId,
    this.lyricFragment,
    this.spinFlag = false,
    this.endingFlag = false,
  });
}

const double kBeatDurationSec = 0.46875; // 60 / 128
const int kTotalBeats = 110;

/// 강/중/약박 구분 (Bar 1~28, 매 4박 = 1마디, 항상 4/4박자 고정)
/// 1st beat=강, 3rd beat=중, 2nd/4th=약
enum BeatStrength { strong, medium, weak }

BeatStrength beatStrengthOf(int beat) {
  final pos = (beat - 1) % 4; // 0,1,2,3
  if (pos == 0) return BeatStrength.strong;
  if (pos == 2) return BeatStrength.medium;
  return BeatStrength.weak;
}

/// 31개 세부 스텝 (Part A: 8종, Part B: 11종, Part C: 12종)
const List<RoutineStep> routineSteps = [
  // ===== Part A (1~32박) 전주 =====
  RoutineStep(
    id: 'A1',
    fullName: '킥글라이드',
    bigLabel: '킥글',
    startBeat: 1,
    endBeat: 4,
    difficulty: 1,
    guide: '오른발 로우킥 후 왼발 볼로 활주, 탭&제동, 무릎 스프링 장전',
    part: 'A',
  ),
  RoutineStep(
    id: 'A2',
    fullName: '말레이시안 셔플',
    bigLabel: 'MS',
    startBeat: 5,
    endBeat: 8,
    difficulty: 3,
    guide: '양발 초저공 홉 → 스냅킥 → 16비트 머신건 탭 → 접지 락',
    part: 'A',
  ),
  RoutineStep(
    id: 'A3',
    fullName: '문워크 런닝맨',
    bigLabel: 'MRM',
    startBeat: 9,
    endBeat: 12,
    difficulty: 2,
    guide: '[왼쪽→오른쪽] 가위스텝 교차하며 우측으로 글라이드',
    part: 'A',
  ),
  RoutineStep(
    id: 'A4',
    fullName: '기본 런닝맨',
    bigLabel: '런닝맨',
    startBeat: 13,
    endBeat: 16,
    difficulty: 1,
    guide: '[오른쪽→왼쪽] 무릎 90도 리프트하며 좌측 원위치 복귀',
    part: 'A',
  ),
  RoutineStep(
    id: 'A5',
    fullName: '런닝맨 더블',
    bigLabel: '런닝맨더블',
    startBeat: 17,
    endBeat: 20,
    difficulty: 2,
    guide: '제자리 스플릿 런지, 디딤발 2연타 더블 바운스로 중심 정렬',
    part: 'A',
  ),
  RoutineStep(
    id: 'A6',
    fullName: '힐 5연속 타격',
    bigLabel: '힐×5',
    startBeat: 21,
    endBeat: 24,
    difficulty: 2,
    guide: '뒤꿈치 오-왼-오-왼-오 5회 연속 교대 타격',
    part: 'A',
  ),
  RoutineStep(
    id: 'A7',
    fullName: '인디언 글라이드',
    bigLabel: 'IG',
    startBeat: 25,
    endBeat: 28,
    difficulty: 3,
    guide: '발 교차(Cross) 후 발볼로 매끄럽게 스윕 글라이드',
    part: 'A',
  ),
  RoutineStep(
    id: 'A8',
    fullName: 'V 스텝',
    bigLabel: 'V',
    startBeat: 29,
    endBeat: 32,
    difficulty: 1,
    guide: '뒤꿈치 모으고 발끝 V자 개방(Out) → 탄성 바운스 → 모음(In)',
    part: 'A',
  ),

  // ===== Part B (33~64박) 1절 벌스 =====
  RoutineStep(
    id: 'B1',
    fullName: '런닝맨 대각선 힐',
    bigLabel: '대각힐',
    startBeat: 33,
    endBeat: 36,
    difficulty: 2,
    guide: '45도 대각선으로 몸을 틀며 뒤꿈치를 콕 찍는 런닝맨',
    part: 'B',
  ),
  RoutineStep(
    id: 'B2',
    fullName: '대각선 힐 더블',
    bigLabel: '대각힐×2',
    startBeat: 37,
    endBeat: 40,
    difficulty: 3,
    guide: '대각선 힐 상태에서 동일 디딤발 2연타 댐퍼 바운스',
    part: 'B',
  ),
  RoutineStep(
    id: 'B3',
    fullName: '킥볼체인지',
    bigLabel: '킥볼체인지',
    startBeat: 41,
    endBeat: 44,
    difficulty: 2,
    guide: '오른발 킥 → 발볼 접지 → 반대 발로 체중 순간 교대',
    part: 'B',
  ),
  RoutineStep(
    id: 'B4',
    fullName: '점핑 힐',
    bigLabel: '점핑힐',
    startBeat: 45,
    endBeat: 46,
    difficulty: 2,
    guide: '2~3cm 가벼운 점프 후 양발 뒤꿈치로 강하게 착지 타격',
    part: 'B',
  ),
  RoutineStep(
    id: 'B5',
    fullName: 'W 스텝',
    bigLabel: 'W',
    startBeat: 47,
    endBeat: 48,
    difficulty: 1,
    guide: '뒤꿈치 축으로 발끝을 W자 궤적으로 열고 닫기',
    part: 'B',
  ),
  RoutineStep(
    id: 'B6',
    fullName: '토힐 4연속 타격',
    bigLabel: '토힐×4',
    startBeat: 49,
    endBeat: 52,
    difficulty: 3,
    guide: '앞꿈치 콕 → 뒤꿈치 쾅, 16비트 속도로 4회 연속 교대',
    part: 'B',
  ),
  RoutineStep(
    id: 'B7',
    fullName: '힐토홉',
    bigLabel: '힐토홉',
    startBeat: 53,
    endBeat: 54,
    difficulty: 2,
    guide: '뒤꿈치-앞꿈치 찍고 가볍게 홉 점프',
    part: 'B',
  ),
  RoutineStep(
    id: 'B8',
    fullName: '힐사이드',
    bigLabel: '힐사이드',
    startBeat: 55,
    endBeat: 56,
    difficulty: 1,
    guide: '측면으로 다리를 뻗어 뒤꿈치로 지면 탭',
    part: 'B',
  ),
  RoutineStep(
    id: 'B9',
    fullName: 'Y 스텝',
    bigLabel: 'Y',
    startBeat: 57,
    endBeat: 60,
    difficulty: 1,
    guide: '양발을 넓게 Y자로 개방 후 제자리로 모으기',
    part: 'B',
  ),
  RoutineStep(
    id: 'B10',
    fullName: 'T스텝 (앞뒤)',
    bigLabel: 'T앞뒤',
    startBeat: 61,
    endBeat: 62,
    difficulty: 2,
    guide: '축발 뒤꿈치 기준 T자로 전방 1박 → 후방 1박 이동',
    part: 'B',
  ),
  RoutineStep(
    id: 'B11',
    fullName: 'T스텝 (옆)',
    bigLabel: 'T옆',
    startBeat: 63,
    endBeat: 64,
    difficulty: 1,
    guide: '측면으로 2박 동안 미끄러지며 하프턴 각도 세팅',
    part: 'B',
  ),

  // ===== Part C (65~110박) 후렴 클라이맥스 =====
  RoutineStep(
    id: 'C1',
    fullName: '하프턴',
    bigLabel: '하프턴',
    startBeat: 65,
    endBeat: 68,
    difficulty: 4,
    guide: '오→왼→오→(발찍고)→왼, 180도 회전',
    part: 'C',
  ),
  RoutineStep(
    id: 'C2',
    fullName: '피봇 턴',
    bigLabel: '피봇턴',
    startBeat: 69,
    endBeat: 72,
    difficulty: 3,
    guide: '축발 중심으로 회전 및 자세 정렬',
    part: 'C',
  ),
  RoutineStep(
    id: 'C3',
    fullName: '런닝맨 대각선',
    bigLabel: '런닝맨대각',
    startBeat: 73,
    endBeat: 74,
    difficulty: 2,
    guide: '45도 대각선 짧은 연결, V스텝으로 잇는 완충 스텝',
    part: 'C',
  ),
  RoutineStep(
    id: 'C4',
    fullName: 'V 스텝',
    bigLabel: 'V',
    startBeat: 75,
    endBeat: 78,
    difficulty: 1,
    guide: '양발 V자 개폐로 착지 밸런스 안정화',
    part: 'C',
  ),
  RoutineStep(
    id: 'C5',
    fullName: 'T스텝 (옆)',
    bigLabel: 'T옆',
    startBeat: 79,
    endBeat: 80,
    difficulty: 1,
    guide: '측면 T형 수평 글라이드로 하프턴 각도 세팅',
    part: 'C',
  ),
  RoutineStep(
    id: 'C6',
    fullName: '하프턴 (정면복귀)',
    bigLabel: '하프턴',
    startBeat: 81,
    endBeat: 84,
    difficulty: 4,
    guide: '2차 하프턴으로 무대 정면 100% 원복',
    part: 'C',
  ),
  RoutineStep(
    id: 'C7',
    fullName: '피봇 턴',
    bigLabel: '피봇턴',
    startBeat: 85,
    endBeat: 88,
    difficulty: 3,
    guide: '정면 축 고정, 찰스턴 하이 도약 탄성 비축',
    part: 'C',
  ),
  RoutineStep(
    id: 'C8',
    fullName: '찰스턴 하이',
    bigLabel: '찰스턴',
    startBeat: 89,
    endBeat: 92,
    difficulty: 4,
    guide: '전후 스윙 후 가슴 높이까지 다리를 차올리는 하이킥',
    part: 'C',
  ),
  RoutineStep(
    id: 'C9',
    fullName: '크리스크로스',
    bigLabel: 'CC',
    startBeat: 93,
    endBeat: 96,
    difficulty: 5,
    guide: '공중에서 양발 X자로 교차하며 도약 착지',
    part: 'C',
  ),
  RoutineStep(
    id: 'C10',
    fullName: '트위스트 힐',
    bigLabel: '트위스트',
    startBeat: 97,
    endBeat: 100,
    difficulty: 3,
    guide: '골반과 양발 뒤꿈치를 좌우로 강하게 비틀기',
    part: 'C',
  ),
  RoutineStep(
    id: 'C11',
    fullName: '원스텝 포워드',
    bigLabel: '원스텝',
    startBeat: 101,
    endBeat: 104,
    difficulty: 2,
    guide: '앞으로 강하게 한 걸음씩 전진하며 텐션 업',
    part: 'C',
  ),
  RoutineStep(
    id: 'C12',
    fullName: '스핀턴 + 말레이시안',
    bigLabel: 'MS',
    startBeat: 105,
    endBeat: 110,
    difficulty: 5,
    guide: '오른발 접어 360도 스핀 → 6박 고속 셔플 → 손 뻗으며 정지',
    part: 'C',
  ),
];

RoutineStep? stepAtBeat(int beat) {
  for (final s in routineSteps) {
    if (beat >= s.startBeat && beat <= s.endBeat) return s;
  }
  return null;
}

RoutineStep? nextStepAfter(RoutineStep current) {
  final idx = routineSteps.indexOf(current);
  if (idx == -1 || idx == routineSteps.length - 1) return null;
  return routineSteps[idx + 1];
}

/// 110박 전체 상세 큐 데이터 (Ⅲ.4 / Ⅳ.3 / Ⅴ.3 표 기반)
final List<BeatCue> beatCues = _buildBeatCues();

List<BeatCue> _buildBeatCues() {
  // (beat, musicNote, footCue, stepId, lyric?)
  final raw = <List<dynamic>>[
    // Part A
    [1, '신스 인트로 첫 강타 (쾅!)', '오른발 발목 45° 로우킥 개시(Flick)', 'A1', null],
    [2, '아르페지오 신스 상승', '왼발 디딤발 볼로 바닥 뒤 15cm 활주(Slide)', 'A1', null],
    [3, '드럼 하이햇 오픈', '오른발 발끝 탭하며 글라이드 제동', 'A1', null],
    [4, '스네어 드럼 샷', '양 무릎 15° 굽혀 착지 충격 흡수 및 장전', 'A1', null],
    [5, '킥 드럼 쿵!', '양발 볼로 1~2cm 초저공 홉 바운스', 'A2', null],
    [6, '신스 브라스 악센트', '오른발 발목 스냅킥 전방 돌출', 'A2', null],
    [7, '16비트 하이햇 연속음', '좌우 발볼 초고속 교차 머신건 탭', 'A2', null],
    [8, '비트 락 & 호흡 정돈', '양발 접지 안착 락(Lock)', 'A2', null],
    [9, '베이스라인 본격 질주 개시', '왼발 디딤 + 오른발 볼 후방 슬라이드 개시', 'A3', null],
    [10, '신스 아르페지오 우측 패닝', '가위스텝 교차하며 우측으로 글라이드', 'A3', null],
    [11, '드럼 킥 연속 타격', '오른발 축 전환 및 왼발 후방 슬라이딩 가속', 'A3', null],
    [12, '소절 마감 다운비트', '무대 우측 안착, 반전 추진력 확보', 'A3', null],
    [13, '강한 4박 킥드럼 (쿵!)', '오른발 무릎 90° 리프트 (플라밍고 포즈)', 'A4', null],
    [14, '스네어 스냅', '오른발 전방 런지 + 왼발 후방 슬라이딩', 'A4', null],
    [15, '신스 리프 상승', '왼발 무릎 90° 리프트하며 좌측 복귀', 'A4', null],
    [16, '베이스 턴어라운드', '좌측 원위치 완전 귀환 안착', 'A4', null],
    [17, '리듬 섹션 1차 엑센트', '스플릿 런지 1차 무릎 댐퍼 바운스', 'A5', null],
    [18, '하이햇 오픈', '동일 디딤발 2차 리듬 바운스 타격', 'A5', null],
    [19, '신스 리듬 2차 엑센트', '양발 교체 스위칭 후 1차 바운스', 'A5', null],
    [20, '드럼 브레이크 직전', '반대 발 2차 바운스로 중심 정렬', 'A5', null],
    [21, '브레이크 1타 + 엇박 2타', '오른발→왼발 뒤꿈치 연속 2회 교대 타격', 'A6', null],
    [22, '드럼 정박 비트 (쿵!)', '오른발 뒤꿈치 3차 타격', 'A6', null],
    [23, '스네어 비트 (착!)', '왼발 뒤꿈치 4차 타격', 'A6', null],
    [24, '5연타 마감 악센트 (쾅!)', '오른발 뒤꿈치 5회차 피니시 타격', 'A6', null],
    [25, '신스 화음 글라이드', '오른발 왼발 앞으로 교차(Cross) 개시', 'A7', null],
    [26, '베이스 저음 스윕', '교차된 양발 볼로 측면 글라이딩', 'A7', null],
    [27, '드럼 필인 개시', '교차 풀며 바닥을 매끄럽게 스윕', 'A7', null],
    [28, '필인 크레센도', '양발 폭 정렬, V스텝 개방 준비', 'A7', null],
    [29, '보컬 진입 카운트다운 (3)', '뒤꿈치 모으고 발끝 60° V자 개방(Out)', 'A8', null],
    [30, '보컬 진입 카운트다운 (2)', 'V자 상태 탄성 바운스로 충격 흡수', 'A8', null],
    [31, '보컬 숨고르기 (1)', '양발끝 안쪽으로 모으며 중심 복귀(In)', 'A8', null],
    [32, '1절 보컬 진입 직전', 'Part A 완결 → Part B 진입 준비', 'A8', '나의 거리에는'],

    // Part B
    [33, '"나의 거리에는" 보컬 개시', '45° 우측 대각선 전환, 오른발 뒤꿈치 타격', 'B1', '나의 거리에는'],
    [34, '베이스 비트 연타', '왼발 후방 슬라이드 런닝맨 전개', 'B1', null],
    [35, '신스 코드 컴핑', '45° 좌측 대각선 전환, 왼발 뒤꿈치 타격', 'B1', null],
    [36, '드럼 스네어 탭', '오른발 후방 슬라이드, 다음 바운스 장전', 'B1', null],
    [37, '"어둠이 또 밀리면"', '대각선 힐 상태에서 동일 발 1차 바운스', 'B2', '어둠이 또 밀리면'],
    [38, '리듬 스냅', '동일 발 연속 2차 더블 바운스 타격', 'B2', null],
    [39, '베이스 드라이브', '반대 대각선 전환 후 1차 바운스', 'B2', null],
    [40, '소절 마감 다운비트', '2차 바운스 완결, 킥볼체인지 정렬', 'B2', null],
    [41, '"하늘엔" 보컬 브릿지', '오른발 전방 가벼운 킥(Kick)', 'B3', '하늘엔'],
    [42, '신스 악센트', '오른발 볼로 바닥 콕, 체중 이전', 'B3', null],
    [43, '드럼 킥 (쿵!)', '왼발로 빠르게 체중 교대(Change)', 'B3', null],
    [44, '하이햇 리듬', '반대 발 킥볼체인지 대칭 완료', 'B3', null],
    [45, '"작은 별 하나"', '양발 가볍게 점프, 양발 뒤꿈치로 지면 타격', 'B4', '작은 별 하나'],
    [46, '스네어 샷', '뒤꿈치 착지 충격 흡수, W스텝 전이', 'B4', null],
    [47, '건반 멜로디 턴', '양발끝 바깥-안쪽 W자 궤적 확장', 'B5', null],
    [48, '2행 종결 다운비트', '발끝 안쪽으로 모아 제자리 회수', 'B5', null],
    [49, '"그 길을 따라" 보컬 상승', '오른발 앞꿈치 콕 → 뒤꿈치 쾅! 연속 타격', 'B6', '그 길을 따라'],
    [50, '신스 리듬 연타', '왼발 앞꿈치 콕 → 뒤꿈치 쾅!', 'B6', null],
    [51, '16비트 베이스라인', '오른발 앞꿈치 콕 → 뒤꿈치 쾅!', 'B6', null],
    [52, '드럼 필인', '왼발 앞꿈치 콕 → 뒤꿈치 쾅!', 'B6', null],
    [53, '"나 홀로 가니"', '오른발 뒤꿈치-앞꿈치 찍고 가볍게 홉(Hop)', 'B7', '나 홀로 가니'],
    [54, '스네어 스냅', '디딤발 탄성 리바운드로 착지', 'B7', null],
    [55, '신스 패드 지속', '오른발 뒤꿈치 우측 측면으로 뻗어 탭', 'B8', null],
    [56, '3행 종결 비트', '측면 발 회수, Y스텝 준비', 'B8', null],
    [57, '"허전한" 감정 고조', '양발 어깨너비보다 넓게 Y자 개방(Out)', 'B9', '허전한'],
    [58, '베이스 저음 웅장', 'Y자 와이드 스탠스에서 중심 낮춤', 'B9', null],
    [59, '드럼 킥 연속', '양발 안쪽으로 서서히 회수(In)', 'B9', null],
    [60, '하이햇 오픈', '양발 11자 평행 정렬, T스텝 축발 세팅', 'B9', null],
    [61, '"발길뿐이네"', '왼발 뒤꿈치 축, 오른발 T자 전방 1박(앞1)', 'B10', '발길뿐이네'],
    [62, '베이스 리듬 전환', '왼발 앞꿈치 축, 오른발 T자 후방 1박(뒤1)', 'B10', null],
    [63, '후렴 직전 드럼 필인', '축발 지그재그, 우측 측면 1박 이동(옆1)', 'B11', null],
    [64, '후렴 폭발 직전 정적 (Stop)', '측면 2박차 완료, 하프턴 발사각 세팅', 'B11', null],

    // Part C
    [65, '"바람아" 후렴 폭발', '[1박: 오른발 디딤] 전방으로 힘차게 내딛으며 회전 시동', 'C1', '바람아 불어라'],
    [66, '신스 브라스 포르테', '[2박: 왼발 축 전환] 90° 시계 반대방향 회전', 'C1', null],
    [67, '드럼 킥 강타 (쿵!)', '[3박: 오른발 회전] 180° 반대 방향으로 시선 전환', 'C1', null],
    [68, '스네어 림샷 (착!)', '[4박: 발 찍고 왼발 착지] 오른발 탭 후 왼발 안착', 'C1', null],
    [69, '"불어라" 고음 서스테인', '왼발 디딤 축으로 피봇 회전 시동', 'C2', null],
    [70, '베이스 옥타브 드라이브', '오른발 스윕하며 밸런스 유지', 'C2', null],
    [71, '하이햇 리듬 오픈', '축발 회전력 흡수, 상체 코어 정렬', 'C2', null],
    [72, '소절 마감 다운비트', '피봇 턴 완결, 대각선 연결 준비', 'C2', null],
    [73, '신스 리프 아르페지오', '45° 우측 대각선으로 오른발 뻗으며 런지', 'C3', null],
    [74, '베이스 슬랩 리듬', '왼발 후방 슬라이드, V스텝 진입 추진력 확보', 'C3', null],
    [75, '드럼 정박 비트', '뒤꿈치 모으고 발끝 60° V자 개방(Out 1박)', 'C4', null],
    [76, '신스 스트링 화음', 'V자 상태 탄성 바운스 충격 흡수(Out 2박)', 'C4', null],
    [77, '드럼 필인 롤', '양발끝 안쪽으로 서서히 모음(In 1박)', 'C4', null],
    [78, '보컬 2행 진입 직전 숨고르기', '11자 평행 정렬 완료', 'C4', '작은 나의'],
    [79, '"작은 나의" 보컬 진입', '왼발 뒤꿈치 축, 오른발 T자 측면 수평 글라이드', 'C5', '작은 나의'],
    [80, '스네어 스냅', '축발 연속 미끄러짐, 2차 하프턴 각도 세팅', 'C5', null],
    [81, '"두 뺨에"', '[1박: 오른발 디딤] 강하게 내딛으며 2차 180° 회전 개시', 'C6', '두 뺨에'],
    [82, '신스 브라스 찌르기', '[2박: 왼발 축 전환] 회전 가속', 'C6', null],
    [83, '베이스 다운비트', '[3박: 오른발 회전] 180° 돌아 정면 시선 100% 원복', 'C6', null],
    [84, '드럼 림샷', '[4박: 발 찍고 왼발 착지] 완벽 안착', 'C6', null],
    [85, '신스 아르페지오 상승', '축발 중심으로 몸을 정면 12시 방향 고정', 'C7', null],
    [86, '베이스 리듬 연속', '회전 관성 상쇄, 양발 코어 중심 정렬', 'C7', null],
    [87, '드럼 하이햇 크레센도', '무릎 댐퍼 낮추며 찰스턴 하이 도약 탄성 비축', 'C7', null],
    [88, '클라이맥스 폭발 1박 전', '정면 시선 픽스 완료', 'C7', '오 바람아'],
    [89, '"오 바람아" 최고음 샤우팅', '오른발 전방 스텝 후 왼발 후방 스윙', 'C8', '오 바람아 불어라'],
    [90, '베이스 16비트 질주', '왼발 뒤로 짚고 오른발 리프트 준비', 'C8', null],
    [91, '드럼 킥 연속 타격', '오른발 가슴 높이까지 힘차게 차올리는 찰스턴 하이킥!', 'C8', null],
    [92, '스네어 폭발 (착!)', '킥 후 착지, 크리스크로스 탄성 장전', 'C8', null],
    [93, '"불어라" 감정 극대화', '양발 도약 후 공중 오른앞/왼뒤 X자 교차 착지', 'C9', '작은 나의 가슴에'],
    [94, '신스 브라스 연타', '바운스 홉하며 양발 원위치 개방', 'C9', null],
    [95, '베이스 리프 변조', '2차 공중 도약, 왼앞/오른뒤 X자 교차 착지', 'C9', null],
    [96, '드럼 필인', '바운스 리바운드로 착지, 트위스트 힐 전환', 'C9', null],
    [97, '"작은 나의"', '양발 뒤꿈치 우측으로 강하게 비틀기 (1회)', 'C10', null],
    [98, '신스 리듬 스냅', '양발 뒤꿈치 좌측 비틀기 (2회)', 'C10', null],
    [99, '베이스 드라이브', '양발 뒤꿈치 우측 연속 타격 (3회)', 'C10', null],
    [100, '하이햇 리듬 오픈', '양발 뒤꿈치 좌측 타격 완결 (4회)', 'C10', null],
    [101, '"가슴에" 감정 정점', '오른발 전방 한 걸음 강하게 내딛음(Step 1)', 'C11', null],
    [102, '신스 패드 웅장', '전방 체중 이전 및 상체 텐션 업(Step 2)', 'C11', null],
    [103, '드럼 킥 강타', '왼발 따라붙이며 전진 모멘텀 유지(Step 3)', 'C11', null],
    [104, '스핀턴 브레이크 직전', '전진 착지 완료, 스핀턴 준비(Step 4)', 'C11', '허전한 맘'],
    [105, '드럼 롤 & 신스 하모니', '[스핀턴] 오른발 접어 360° 회전 → 오른발 스냅킥 & 바운스', 'C12', '허전한 맘'],
    [106, '베이스 슬랩 리듬', '왼발 스프링보드 머신건 탭', 'C12', null],
    [107, '비트 가속화', '오른발 착지 락, 반대 발 스위칭', 'C12', null],
    [108, '스네어 스냅 (착!)', '왼발 스냅킥 연타', 'C12', null],
    [109, '"맘 지우게" 보컬 종결', '오른발 머신건 탭, 최후 에너지 방출', 'C12', '지우게'],
    [110, '후렴 종결 강타 (쾅!)', '양발 접지 락, 팔을 전방으로 힘차게 뻗으며 완전 정지!', 'C12', null],
  ];

  return raw.map((r) {
    final beat = r[0] as int;
    final start = (beat - 1) * kBeatDurationSec;
    final end = beat * kBeatDurationSec;
    return BeatCue(
      beat: beat,
      startSec: start,
      endSec: end,
      musicNote: r[1] as String,
      footCue: r[2] as String,
      stepId: r[3] as String,
      lyricFragment: r[4] as String?,
      spinFlag: beat == 105,
      endingFlag: beat == 110,
    );
  }).toList();
}

BeatCue? cueAtBeat(int beat) {
  if (beat < 1 || beat > kTotalBeats) return null;
  return beatCues[beat - 1];
}
